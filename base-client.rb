#
# Cookbook Name:: base-client
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'apt-get-update' do
  command 'sudo apt-get update'
end

package 'lxde' do
  action :install
end

service 'lxdm' do
  action [ :enable, :start ]
end

package 'xrdp' do
  action :install
end

%w{tomcat7 default-jdk libcairo2-dev libpng12-dev libossp-uuid-dev libfreerdp-dev make vsftpd}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{/usr/share/tomcat7/.guacamole /var/lib/guacamole/ /etc/guacamole /etc/guacamole/extensions}.each do |path|
  execute "create folder #{path}" do
    command "sudo mkdir #{path}"
    not_if { ::File.exists?("#{path}") }
    action :run
  end
end

version = node['guacamole']['version']

remote_file "#{Chef::Config[:file_cache_path]}/guacamole-server-#{version}.tar.gz" do
  source "http://ufpr.dl.sourceforge.net/project/guacamole/current/source/guacamole-server-#{version}.tar.gz"
  mode '0755'
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/guacamole-server-#{version}.tar.gz") }
end

bash 'build-and-install-guacamole-server' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xzf guacamole-server-#{version}.tar.gz
    (cd guacamole-server-#{version} && ./configure --with-init-dir=/etc/init.d)
    (cd guacamole-server-#{version} && sudo make && sudo make install && sudo ldconfig)
  EOF
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/guacamole-server-#{version}") }
end

remote_file "/var/lib/guacamole/guacamole.war" do
  source "http://ufpr.dl.sourceforge.net/project/guacamole/current/binary/guacamole-#{version}.war"
  mode '0755'
  not_if { ::File.exists?("/var/lib/guacamole/guacamole.war") }
end

%w{guacamole.properties}.each do |file|
  cookbook_file "/etc/guacamole/#{file}" do
    source "#{file}"
    mode '0755'
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/guacamole-auth-noauth-#{version}.tar.gz" do
  source "http://ufpr.dl.sourceforge.net/project/guacamole/current/extensions/guacamole-auth-noauth-#{version}.tar.gz"
  mode '0755'
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/guacamole-auth-noauth-#{version}.tar.gz") }
end

bash 'guacamole-auth-noauth' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xzf guacamole-auth-noauth-#{version}.tar.gz
    (sudo mv guacamole-auth-noauth-#{version}/guacamole-auth-noauth-#{version}.jar /etc/guacamole/extensions/guacamole-auth-noauth-#{version}.jar)
    (sudo ln -s /var/lib/guacamole/guacamole.war /var/lib/tomcat7/webapps)
    (sudo ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat7/.guacamole/)
  EOF
  not_if { ::File.exists?("/etc/guacamole/extensions/guacamole-auth-noauth-#{version}.jar") }
end

ruby_block "edit tomcat7 file" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/default/tomcat7")
    fe.insert_line_if_no_match(/GUACAMOLE_HOME/, "GUACAMOLE_HOME=/etc/guacamole")
    fe.write_file
  end
  not_if { ::File.foreach("/etc/default/tomcat7").grep(/GUACAMOLE_HOME/).any? }
  notifies :restart, 'service[tomcat7]'
end

execute 'create_folder_sharedfile' do
  command "sudo mkdir /var/lib/tomcat7/webapps/ROOT/sharedfile/"
  not_if { ::File.directory?("/var/lib/tomcat7/webapps/ROOT/sharedfile/") }
  action :run
end

execute 'create_folder_bash_script' do
  command "sudo mkdir /var/lib/tomcat7/webapps/ROOT/bash_script/"
  not_if { ::File.directory?("/var/lib/tomcat7/webapps/ROOT/bash_script/") }
  action :run
end

execute 'create_folder_execute_command' do
  command "sudo mkdir /var/lib/tomcat7/webapps/ROOT/execute_command/"
  not_if { ::File.directory?("/var/lib/tomcat7/webapps/ROOT/execute_command/") }
  action :run
end

execute 'create_folder_install_from_source' do
  command "sudo mkdir /var/lib/tomcat7/webapps/ROOT/install_from_source/"
  not_if { ::File.directory?("/var/lib/tomcat7/webapps/ROOT/install_from_source/") }
  action :run
end

service "guacd" do
  supports :status => true
  action :start
end

service "tomcat7" do
  supports :status => true
  action :start
end

template '/etc/vsftpd.conf' do
  source 'vsftpd.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'execute_command' do
  user 'root'
  command 'sudo service vsftpd restart'
end

#https://sourceforge.net/p/guacamole/discussion/1110834/thread/3364d8ed/
execute 'set_guacd_start_service' do
  user 'root'
  command 'sudo update-rc.d guacd defaults'
end

template '/etc/rc.local' do
  source 'rc.local.erb'
  owner 'root'
  group 'root'
  mode '0755'
end
