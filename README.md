# pivotal-tasks

An alternate, simpler view of Pivotal with a GTD approach to Tasks.

Tasks in Pivotal: through the standard client, it is possible to complete a
card without finishing all of the tasks on the card, but it is difficult to
find and guarantee post-hoc completion of all those incomplete tasks after the
completion of the sprint.

Developers are left to their own devices with the API if they don't want to
drill down into the cards hunting for incomplete follow-up tasks.

This is against Agile because a task may be added after the Sprint Planning was
already completed.  Those tasks may not be required for acceptance of a story,
but in the agile tracker there is no more convenient interface for follow-up
tasks than to attach them directly to the card, where they can be in context.

Those tasks may not always warrant creation and estimation of another full
1-point (6 hour) story card, but their completion can still be tracked,
guaranteed and quantified through the API.

This project is intended to provide a dashboard and GTD interface to tasks.

* Ruby version: ruby-2.3.5

* System dependencies:
  * PostgreSQL Database
  * Pivotal API KEY and Pivotal Project
  * An HTTP Listening Port Number

* Configuration
    Set environment variables:
```
DATABASE_URL=postgres://pivotal_tasks:[secret]@deis-database.deis.svc.cluster.local/[pivotal_tasks_development]

PIVOTAL_API_KEY=00000000000000000000000000000000
PIVOTAL_PROJECT=k
PORT=5000
DEVELOPMENT_CAS_URL=http://faker.kube.nerdland.info/
```

* Database creation
```
    rake db:migrate:status
```

* Database initialization
```
    rake db:migrate
```

* How to run the test suite
```
    bundle exec rspec
```

* Services (job queues, cache servers, search engines, etc.)
    You need a CAS service to provide authentication of users.  Check out
    http://casino.rbcas.com/ to get an idea of how to put one together.

    I decided to make mine based on https://github.com/rbCAS/CASinoApp

* Deployment instructions
    To send your checkout to Workflow, set environment variables in .env

    ```
    deis create
    deis config:push
    deis healthchecks:set liveness httpGet 5000 --path /ping --type web
    deis healthchecks:set readiness httpGet 5000 --path /ping --type web
    git push deis
    ```

* ...
    NB: for Deis Workflow, values in .buildpacks and Procfile were set.
    Adjust them to control Deis deployment and build parameters.
