module VagrantWindowsGuestNfs
class VagrantWindowsGuestNfsPlugin < Vagrant.plugin("2")
    name "vagrant_windows_guest_nfs"

    guest_capability(:windows, :nfs_client_installed) do
        require_relative 'mount_nfs_folder'
        MountNfsFolder
    end

    guest_capability(:windows, :mount_nfs_folder) do
        require_relative 'mount_nfs_folder'
        MountNfsFolder
    end
end
end
