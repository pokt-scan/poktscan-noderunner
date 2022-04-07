## Poktscan Node Runner Deployment

### Clone this repository

```git clone https://github.com/pokt-scan/poktscan-core-deployment```

### Set company domain

```export COMPANY_DOMAIN={{Your company domain}}```
```eg. export COMPANY_DOMAIN=poktscan.net```

### Setup the infrastrucuture

The setup script assumes your signed in as a sudoer user

```./setup.sh```


### Successful execution

When all steps have been executed without errors, the script prints:

"Setup has been successful!"

The absence of this message means the script did not complete.