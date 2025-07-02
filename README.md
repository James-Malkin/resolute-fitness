# Resolute Fitness
[![Build Status](https://github.com/James-Malkin/resolute-fitness/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/James-Malkin/resolute-fitness/actions?query=branch%3Amain)
[![Deploy Status](https://github.com/James-Malkin/resolute-fitness/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/James-Malkin/resolute-fitness/actions?query=branch%3Amain)

This project was created as part of my dissertation for:

*Bachelor of Science with Honours in Digital & Technology Solutions (Software Engineering)*

It is a gym booking and membership management system adopting automated deployments using Ansible and Kamal.

## Development

The application requires the `master.key` to be written in the `/config` directory.

### Database

To prepare the database, run:

```bash
rails db:prepare
```

### Running the app

Once the database has been prepared, run the app with:

```bash
bin/dev
```

## Tool Versions

| Tool | Version |
|------|:-------:|
|Ruby|3.3.3 |
|PostgreSQL| 17 |