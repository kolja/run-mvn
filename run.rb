#!/usr/bin/env ruby

require 'docopt'
doc = "Usage: run [options] <arguments>...

Options:
    -h --help       show this message and exit
    -v --version    show version and exit
    -t --test       build only -- don't run
    -b --branch=xy  run the specified branch (if present)"

if __FILE__ == $0
    options = Docopt(doc, '1.0.0')  # parse options based on doc above

    ENV['JAVA_OPTS'] = "-Xmx2048m -XX:MaxPermSize=400m"
    ENV['MAVEN_OPTS'] = "-Xmx2048m -XX:MaxPermSize=400m"

    if (options[:branch])
        dir = "~/reboot/branches/R12_00_#{options[:branch]}/zalando-shop"
        if (File.directory? dir)
            puts "running branch #{options[:branch]}"
            exec( "cd #{dir}; mvn clean tomcat:run -Pdevelopment" )
        else
            puts "no such directory: #{dir}"
        end
    else
        dir = "~/reboot/trunk/zalando-shop"
        if (options[:test])
            puts "test-building trunk"
            exec( "cd #{dir}; mvn clean install -Pdevelopment" )
        else
            puts "running trunk"
            exec( "cd #{dir}; mvn clean tomcat:run -Pdevelopment" )
        end
    end
      
end
