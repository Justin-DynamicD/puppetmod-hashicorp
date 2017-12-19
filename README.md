# contoso_hashicorp
This module manages installation of the core Hashicorp tools used as well as base templates
for operation.  Installation of components are managed by leveraging scripts
from registry.terraform.io (thus functionally idenitical to terraform deployments), whereas
actual templates are then copied to be leveraged by consul-template.

Why Contoso?  Becuase at my last company we'd prefix internal modules this way to easily 
identify them as being company spcific, but as it contains no company info I figured I'd 
rename and share.

Currently only works against Ubuntu, as I'm only accounting for systemd.