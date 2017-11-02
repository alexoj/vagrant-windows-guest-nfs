require "vagrant/util/template_renderer"
require "base64"

module VagrantWindowsGuestNfs
class MountNfsFolder
    def self.nfs_client_installed(machine)
        machine.communicate.test("sc query nfsclnt")
    end

    def self.mount_nfs_folder(machine, ip, folders)
        setup_guest_anon_uid(machine)

        folders.each do |name, opts|
            guest_path = Shellwords.escape(opts[:guestpath])
            host_path  = Shellwords.escape(opts[:hostpath].sub(/^\//, '').gsub('/', "\\"))

            path = File.expand_path("../scripts/mount_nfs_folder.ps1", __FILE__)
            script = Vagrant::Util::TemplateRenderer.render(path, options: {
                ip: ip,
                guest_path: guest_path,
                host_path: host_path,
            })
            run_script(machine, script)
        end
    end

    protected

    def self.setup_guest_anon_uid(machine)
        path = File.expand_path("../scripts/change_anon_uid.ps1", __FILE__)
        script = Vagrant::Util::TemplateRenderer.render(path, options: {
            uid: Process.uid,
            gid: Process.gid,
        })
        run_script(machine, script)
    end

    def self.run_script(machine, script)
        if machine.config.vm.communicator == :winrm || machine.config.vm.communicator == :winssh
            machine.communicate.execute(script, shell: :powershell)
        else
            # Convert script to double byte unicode string then base64 encode
            # just like PowerShell -EncodedCommand expects.
            # Suppress the progress stream from leaking to stderr.
            wrapped_encoded_command = Base64.strict_encode64(
                "$ProgressPreference='SilentlyContinue'; #{script}; exit $LASTEXITCODE".encode('UTF-16LE', 'UTF-8'))
            # Execute encoded PowerShell script via OpenSSH shell
            machine.communicate.execute("powershell.exe -noprofile -executionpolicy bypass " +
                                        "-encodedcommand '#{wrapped_encoded_command}'", shell: "sh")
        end
    end

end
end
