class puppet{
	package{ 'vim': 
		name => 'vim',
		ensure => 'installed',
	}
	
	package{ 'curl':
		name => 'curl',
		ensure => 'installed',
	}

	package{ 'git' :
		name=> 'git',
		ensure => 'installed',
	}


	user { 'monitor':	
		ensure => 'present',
		home => '/home/monitor',
		managehome => true,
		shell => '/bin/bash',
	}


	file { '/home/monitor/scripts': 
		ensure => 'directory',
	}

	exec { 'wget':
		command => '/usr/bin/wget https://rawgit.com/daderoxas/SE_exercise/master/memory_check.sh -O memory_check', 
		path => '/home/monitor/scripts',
		cwd => '/home/monitor/scripts',
	}	


	file { '/home/monitor/src/': 
		ensure => 'directory',
	}
	
	file { '/home/monitor/src/my_memory_check':
		ensure => '/home/monitor/scripts/memory_check',
	}


	cron { 'memcheck': 
		command => 'sh /home/monitor/src/my_memory_check -c 90 -w 60 -e danthony0209@gmail.com',
		user => 'root',
		minute => '*/10',
	}


	class {
		timezone => 'PHT',
	}

	host { 
  		name => 'bpx.server.local',
	}
	
	
}

include puppet
