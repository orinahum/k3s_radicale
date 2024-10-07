# Suggestions

### Project

Great work on the project organization!!!

### README

- Missing link to  installation file
- Missing link to task file

### INSTALL SCRIPT
- Missing version/purpose/author/ in shell script
- Missing strict mode (set -o pipefail; set -o errfail)
- Good work on value setup, but needs to be somewhat dynamic value pass, e.g. latest="${$1:-3.2.3}"
- Great use of menu, yet seems little bit too messy for maintanence. 
    - Use `printf` to structure the output for the user
    - Great use of case/esac yet you do not consider case where user inputs something that is not an option
    - Too many static values (sleep __2__) suggested to use global variable in case of future maintanence
- With `kubectl -f` you can pass any amount of files, or structure them into one single file
- Do Not keep encoded values in code !!!
    - Use shell script to get value from user, encode it into global value and use it while running the script 
    - Or write is down to temporary file in remote location and remove it at the end of the run

### Docker
- lines 8-17: why not use multi-container build ?
- lines 24-27: No need to copy files one by one. Copy folder to folder
- line 29: if the applicatin is using user root, no need to set permision in docker file
    - always set permission in project, so not to trouble yourselves

### K8s
- why not use template files of `deployment.yml` and `service.yml` and manipulate them with shell script ? (sed command)
- Keeping encoded values in git is a bad idea, alway use dynamic approach of either using Env variable to insert encoded password or write the
- Missing PV.yml


