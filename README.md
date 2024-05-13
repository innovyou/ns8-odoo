# ns8-odoo

Start and configure a odoo instance.

## Version

1.0.0

## Documentation

See docs: https://docs.nethserver.org/projects/ns8/en/latest/odoo.html

## Install

Instantiate the module with:

    add-module ghcr.io/innovyou/odoo:1.0.0 1

The output of the command will return the instance name.
Output example:

    {"module_id": "odoo1", "image_name": "odoo", "image_url": "ghcr.io/innovyou/odoo:1.0.0"}

## Configure

Let's assume that the odoo instance is named `odoo1`.

Launch `configure-module`, by setting the following parameters:
- `host`: a fully qualified domain name for the application
- `http2https`: enable or disable HTTP to HTTPS redirection
- `lets_encrypt`: enable or disable Let's Encrypt certificate

Example:

```
api-cli run configure-module --agent module/odoo1 --data - <<EOF
{
  "host": "odoo.domain.com",
  "http2https": true,
  "lets_encrypt": false
}
EOF
```

The above command will:
- start and configure the odoo instance
- configure a virtual host for trafik to access the instance

## Get the configuration

You can retrieve the configuration with

```
api-cli run get-configuration --agent module/odoo1 --data null | jq
```

## Access the database

You can access the database of a running instance using this command:
```
podman exec -ti postgres psql -U odoo
```

## Smarthost discovery

Odoo registers to the event smarthost-changed, each time you enable or disable the smarthost settings in the node, you restart odoo.
Before to start the containers we trigger the script discover-smarthost to find and write to an environment file `smarthost.env` the settings of the smarthost and enable the email notification.

## Uninstall

To uninstall the instance:

    remove-module --no-preserve odoo1

## Testing

Test the module using the `test-module.sh` script:


    ./test-module.sh <NODE_ADDR> ghcr.io/innovyou/odoo:1.0.0

The tests are made using [Robot Framework](https://robotframework.org/)

## UI translation

Translated with [Weblate](https://hosted.weblate.org/projects/ns8/).

To setup the translation process:

- add [GitHub Weblate app](https://docs.weblate.org/en/latest/admin/continuous.html#github-setup) to your repository
- add your repository to [hosted.weblate.org](https://hosted.weblate.org) or ask a NethServer developer to add it to ns8 Weblate project
