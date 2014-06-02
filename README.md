# Redmine Plugin Scaffold generator

## Scaffold

### Usage

```
ruby script/rails redmine_plugin_scaffold polls PoolQuestions name:string description:string
```

### Generate

* Migration
* Model
* Controller - with find and build action
* Actions - new, edit, destroy

## Migration

### Usage

```
ruby script/rails redmine_plugin_migration <plugin_name> <migration_name> <model> <field[:type[:index]]> <field[:type[:index]]> ...
ruby script/rails redmine_plugin_migration pools AddVoteAuthor
ruby script/rails redmine_plugin_migration pools AddVoteAuthor Pool
author_id:integer
```


### Generate

* Migration with fields order only with name and next migration number
