# Get an output of a Terraform Cloud workspace via API

### Create a Workspace on Terraform Cloud containing some declared [output](https://www.terraform.io/docs/configuration/outputs.html)

#### Get the repo

```
git clone https://github.com/achuchulev/tfc-api-get-output.git
cd tfc-api-get-output
```

#### Configure Terraform Cloud remote backend

- create `.terraformrc` [file](https://www.terraform.io/docs/commands/cli-config.html) and put your TFC token

```
credentials "app.terraform.io" {
  
  # TFE user token
  token = "your_terraform_token"
}
```

- Adjust `backend.tf`

```
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "<ORGANIZATION>"

    workspaces {
      name = "<WORKSPACE>"
    }
  }
}
```

#### Set terraform variable in the TFC workspace via UI

```
words_number = 4
```

`Note: You can do that also using tfe provider from CLI`

example:

```
resource "tfe_variable" "test" {
  key          = "words_number"
  value        = "4"
  category     = "terraform"
  workspace_id = "<ORGANIZATION>/<WORKSPACE>"
}
```

#### Initialize backend from CLI

```
terraform init
```

#### Apply changes to generate some output

```
terraform apply
```

## Extract outputs via API

1. Export your TFC token

```
export TOKEN="your_terraform_cloud_token"
```

2. Get WS ID by ORG_name && WS name

> example:

```
$ curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/<ORGANIZATION>/workspaces/<WORKSPACE> | jq '.data | .id'
```

```
***"ws-xxxxxxxxxxxx"***
```
	
3. Get current state version output ids

  > example:
  
  ```
  $ curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/workspaces/<WORKSPACE>/current-state-version?include=outputs | jq '.included'
  ```
  
  ```
[
  {
    "id": "wsout-i3M7zAqJ9qbKdRkH",
    "type": "state-version-outputs",
    "attributes": {
      "name": "echo",
      "sensitive": false,
      "type": "array",
      "value": [
        "7339402641891683797",
        "1149883287266929181",
        "2093789501086708733",
        "4349865991131460556"
      ]
    },
    "links": {
      "self": "/api/v2/state-version-outputs/wsout-i3M7zAqJ9qbKdRkH"
    }
  },
  {
    "id": "wsout-8sXsGngXLGTrrToi",
    "type": "state-version-outputs",
    "attributes": {
      "name": "random_name",
      "sensitive": false,
      "type": "string",
      "value": "ideally-hideously-prepared-treefrog"
    },
    "links": {
      "self": "/api/v2/state-version-outputs/wsout-8sXsGngXLGTrrToi"
    }
  }
]
  ```
  
4. Get attributes of specific output
   
  > examples:
  
  ```
  $ curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/state-version-outputs/wsout-8sXsGngXLGTrrToi | jq
  ```
  
  ```
   {
    "data": {
      "id": "wsout-8sXsGngXLGTrrToi",
      "type": "state-version-outputs",
      "attributes": {
        "name": "random_name",
        "sensitive": false,
        "type": "string",
        "value": "ideally-hideously-prepared-treefrog"
      },
      "links": {
        "self": "/api/v2/state-version-outputs/wsout-8sXsGngXLGTrrToi"
      }
    }
  }
  ```
  
  ```
  $ curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/state-version-outputs/wsout-i3M7zAqJ9qbKdRkH | jq
  ```
  
  ```
{
  "data": {
    "id": "wsout-i3M7zAqJ9qbKdRkH",
    "type": "state-version-outputs",
    "attributes": {
      "name": "echo",
      "sensitive": false,
      "type": "array",
      "value": [
        "7339402641891683797",
        "1149883287266929181",
        "2093789501086708733",
        "4349865991131460556"
      ]
    },
    "links": {
      "self": "/api/v2/state-version-outputs/wsout-i3M7zAqJ9qbKdRkH"
    }
  }
}
  ```
  
  - Get attributes `name` and `value` of specific output
  
  ```
  $ curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/state-version-outputs/wsout-8sXsGngXLGTrrToi | jq '.data | .attributes.name, .attributes.value'
  ```
  
  ```
  "random_name"
  "ideally-hideously-prepared-treefrog"
  ```
  
  - Get attributes `name` and ***first*** `value` of specific output
  
  ```
   $ curl \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \ 
    https://app.terraform.io/api/v2/state-version-outputs/wsout-i3M7zAqJ9qbKdRkH | jq '.data | .attributes.name, .attributes.value[0]'
  ```
  
  ```
  "echo"
  "7339402641891683797"
  ```
  
