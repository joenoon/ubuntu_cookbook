class Chef::Provider::Service::LucidUpstart < Chef::Provider::Service::Upstart
  def initialize(new_resource, run_context)
    super
    @upstart_job_dir = "/etc/init"
    @upstart_conf_suffix = ".conf"
  end
end
