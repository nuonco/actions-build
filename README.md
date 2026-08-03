# Build Component

This action will create a new build of a Nuon component.

This is a composite action that uses the [Nuon CLI](https://docs.nuon.co/cli). If you need a more sophisticated integration, you can use the CLI directly from GitHub Actions or another automation platform.

Refer to [our docs](https://docs.nuon.co) for more information on builds and the Nuon platform generally.

## Inputs

- `org_id`: Your Nuon org ID.
- `app_id`: The ID or name of the app containing the component.
- `component_id`: The ID or name of the component to build.
- `api_token`: A Nuon API token. Optional when using GitHub Actions OIDC.
- `api_url`: The Nuon API URL. Defaults to Nuon Cloud.

## Outputs

- `build_id`: The ID of the build that was created.

## OIDC authentication

OIDC avoids storing a Nuon API token in GitHub. Create a Nuon OIDC trust policy for the repository and branch, then grant the workflow permission to request an ID token:

```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'components/my-component/**'
      - 'nuon/my-component.tf'

permissions:
  contents: read
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build component
        id: build
        uses: nuonco/actions-build@v1.5.3
        with:
          org_id: ${{ vars.nuon_org_id }}
          app_id: ${{ vars.nuon_app_id }}
          component_id: ${{ vars.nuon_component_id }}
```

## API token fallback

If OIDC is unavailable, store a Nuon API token as a GitHub Actions secret and pass it to the action:

```yaml
- name: Build component
  uses: nuonco/actions-build@v1.5.3
  with:
    api_token: ${{ secrets.nuon_api_token }}
    org_id: ${{ vars.nuon_org_id }}
    app_id: ${{ vars.nuon_app_id }}
    component_id: ${{ vars.nuon_component_id }}
```
