#
# Cookbook Name:: sshd
# Recipe:: node
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package node['sshd']['package'] do
  action :install
end

if node['sshd']['conf_lists'] != nil
  node['sshd']['conf_lists'].each_pair do |name, value|
    ruby_block "replace_set_sshd_config_#{name}" do
      block do
        _fe = Chef::Util::FileEdit.new(node['sshd']['sshd_config'])
        # 追加
        _fe.insert_line_if_no_match('^' + name + " " + value, name + " " + value)
        # 置き換え
        _fe.search_file_replace('^' + name + "(\t|\s)+" + value, name + " " + value)
        _fe.write_file
      end
      notifies :restart, "service[" + node['sshd']['service_name'] + "]"
    end
  end
end
    # execute "replace_set_sshd_config_#{name}" do
    #   command "sed -i -e \"s/^#{name} \.*/#{name} #{value}/g\" " + node['sshd']['sshd_config']
    #   not_if "egrep '^#{name} #{value}' " + node['sshd']['sshd_config']
    #   notifies :restart, "service[" + node['sshd']['service_name'] + "]"
    # end
    # execute "add_sshd_config_#{name}" do
    #   command "echo '#{name} #{value}' >> " + ['sshd']['sshd_config']
    #   not_if "egrep '^#{name} #{value}' " + ['sshd']['sshd_config']
    #   notifies :restart, "service[" + node['sshd']['service_name'] + "]"
    # end

service node['sshd']['service_name'] do
  action [:enable, :start]
  supports :status => true, :restart => true
end
