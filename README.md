There are still some manual steps required in order to bootstrap the cicd-template project: 
1) You must associate the git server ("vc") with a GitHub remote repo that will constitute the ultimate version of your system's code.  [This is currently done by manipulating the pull request in the Dockerfile of the /vc directory.]
2) You must copy your SSH key into the git server's build context (/vc) such that it can authenticate to GitHub for its initial pull.
3) You must manually conclude the Jenkins launcher process, setting the administrator credentials.  [I do not yet know how to fully automate this, or whether it's even possible.] 

After this initial bootstrap, simply run:
$ docker-compose up
... any time you would like your local deployment pipeline and you will have it.  Containers may be stopped and restarted at any time without loss of configuration.  If you want to permanently persist your code, please push to a GitHub remote.  Alternatively, it may be desirable to set up a Jenkins post-build job that pushes to GitHub upon successful builds for more durable persistence.  

The ci container is bound to a volume on the host at the location ./ci/jenkins-data/.  This is done to avoid loss of jenkins' manually-configured build jobs upon container loss.  Loss of the local disk would, however, still lead to loss of the local ci server's configuration, and so consider backup strategies according to perceived risk of rework.  One option is to extract the list of plugins and jenkins' jobs directory into your project's directory by using the jenkins_backup.sh script.  Persist the output of this script into GitHub along with your project.  You could even automatically invoke this script upon all pushes via git hook or schedule it as a cron job.  Bootstrapping the cicd pipeline on a new development machine would then additionally entail overwriting the /ci/plugins.txt file and /jenkins_jobs/ directory in order to retain the old configuration.

To use your new development environment, simply learn the IP addresses of the containers docker-compose up generates:
$ docker ps
And then clone from the version control container:
$ git clone ssh://git@ip.of.vc.cont/path/to/repo
or push to that repo:
$ git push ssh://git@ip.of.vc.cont/path/to/repo
You should establish a Jenkins job on the continuous integration container ("ci") such that pushes to the vc container automatically trigger a new build.

To Do list:
1) Password-less authentication for pushes to the vc server.
2) Make bootstrapping easier with a bootstrap.sh script to request: a) the location of SSH keys and b) the GitHub remote to use as master repo.  These variables should be used to parameterize the vc context and Dockerfile, rather than continuing with the existing hardcodes.
3) Investigate further automation of the jenkins launcher.
4) Publish this project into a public GitHub repo.
5) Write jenkins_backup.sh script.  This should allow one to restore a lost cicd pipeline onto a new development machine.  It would do this by extracting and storing old jenkins build jobs and plugins.  The script should be bi-directional, both saving and restoring jenkins setups according to the flag used. 