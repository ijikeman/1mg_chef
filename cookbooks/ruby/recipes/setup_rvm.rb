%['curl' 'curl-devel' 'gcc' 'gcc-c++' 'git' 'openssl-devel' 'httpd-devel' 'readline-devel' 'tk-devel' 'make' 'zlib-devel' 'libffi-devel'].each do |pkg|
  package pkg do
    action :install
  end
end

package 'libyaml-devel' do
  options '--enablerepo=epel'
  action :install
end

execute 'setup_rvm' do
  command "bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm ... -installer )"
  action run
end
