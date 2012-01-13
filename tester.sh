#
# Tests the performance changes of LuaServer using the git history
#

# earlierst commit to test
FIRST_COMMIT="a4f321a9148a7283a3a51b0c8ab045c97d6d7fdf"

# latest commit to test
LATEST_COMMIT="HEAD"

# get a list of commits to test
COMMITS=`git log ${FIRST_COMMIT}^..${LATEST_COMMIT} --reverse | grep commit | sed -e 's/commit //'`


RESULTSFILE="results.txt"


rm -f ${RESULTSFILE}

for c in $COMMITS; do

    git reset --hard $c
    echo $c >> "${RESULTSFILE}"
    git show $c | head -n 5 | tail -n 1 >> "${RESULTSFILE}"
    lua server.lua &
    sleep 5
    ab -n 10000 -c 10 -k http://127.0.0.1:8080/ | grep "Requests per second" >> "${RESULTSFILE}"
    killall lua
    echo >> "${RESULTSFILE}"

done

