#!/bin/bash

# the list of GitHub repositories built by maven
project_list="/media/troy/Disk2/ONR/BigQuery/sample-maven-projects.csv"

# the root directory that contains the Java projects downloaded from GitHub
project_dir="/media/troy/Disk2/ONR/BigQuery/sample-projects"


# check whether the project directory exists first
if [ ! -d "$project_dir" ]; then
	printf "The root directory of GitHub projects does not exist.\n"
	exit 1
fi

while read line
do
	#echo "$line"
	if [[ $line != *"/"* ]]; then
		# incorrect repo name
		continue
	fi
	line=`echo $line | awk -F'\r' '{print $1}'`
	username=`echo $line | awk -F'/' '{print $1}'`
	reponame=`echo $line | awk -F'/' '{print $2}'`
	#echo "Name=${username}; Repo=${reponame}"
	project="${username}_${reponame}"

	if grep -q 'BUILD SUCCESS' ${project_dir}/${project}/onr_build.log; then
		# only run tests in projects that have successfully built
		if [ -f "${project_dir}/${project}/onr_test.log" ]; then
			printf "$line has already been tested.\n\n"
		else
			printf "Begin to test $line\n"
			`mvn test -f "${project_dir}/${project}/pom.xml" &> ${project_dir}/${project}/onr_test.log` 
			printf "Finish testing $line\n\n"
		fi
	fi
done < $project_list
