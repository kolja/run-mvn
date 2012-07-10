#!/usr/bin/env ruby

require 'docopt'
doc = "Usage: run [options] <arguments>...

Options:
    -h --help       show this message and exit
    -v --version    show version and exit
    -t --test       build only -- don't run
    -d --debug      run in debug-mode
    -b --branch=xy  run the specified branch (if present)
    -r --root=root  path to root directory (default: ~/reboot)"

if __FILE__ == $0
    options = Docopt(doc, '1.0.0')  # parse options based on doc above

    ENV['JAVA_OPTS'] = "-Xmx2048m -XX:MaxPermSize=400m"
    ENV['MAVEN_OPTS'] = "-Xmx2048m -XX:MaxPermSize=400m"

    if (options[:debug])
        command = "mvnDebug"
    else
        command = "mvn"
    end

    if (options[:branch])
        dir = "#{options[:root]}/branches/R12_00_#{options[:branch]}/zalando-shop"
        if (File.directory? dir)
            puts "running branch #{options[:branch]}"
            exec( "cd #{dir}; #{command} clean tomcat:run -Pdevelopment" )
        else
            puts "no such directory: #{dir}"
        end
    else
        dir = "#{options[:root]}/trunk/zalando-shop"
        if (options[:test])
            puts "test-building trunk"
            exec( "cd #{dir}; #{command} clean install -Pdevelopment" )
        else
            puts "running trunk"
            exec( "cd #{dir}; mvn clean tomcat:run -Pdevelopment" )
        end
    end
      
end
