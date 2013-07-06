execute "import data" do
	command "mysql -uroot -p#{node[:mysql][:server_root_password]} < /vagrant/init.sql"
	user "vagrant"
end

#php_pear "xdebug" do
  # Specify that xdebug.so must be loaded as a zend extension
#  zend_extensions ['xdebug.so']
#  action :install
#end

Dir.glob("/vagrant/cookbooks/any/files/default/root/**/*") { |x| 
	next if File.directory? x
	to = '/' + x["/vagrant/cookbooks/any/files/default/root/".length, x.length]
	from = x["/vagrant/cookbooks/any/files/default/".length, x.length]

	puts "------"
	puts from + " --> " + to
	puts "----"


	remote_file to do
	  source from
	  mode 0777
	end
}


service "mysql" do
  action :reload
end

service "apache2" do
  action :reload
end

link "/var/www/proj" do
  to "/vagrant/webroot"
end

link "/vagrant/webroot/pimcore" do
  to "/vagrant/vendors/pimcore/pimcore"
end
