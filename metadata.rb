name             'reprepro'
maintainer       'Nick Charlton'
maintainer_email 'nick@nickcharlton.net'
license          'MIT'
description      'Configures reprepro to host apt repsitories.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# it can, after all, only support debian derivatives
supports 'debian'
supports 'ubuntu'

depends 'nginx'

