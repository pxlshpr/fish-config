function gt -d "bump git tag"
    set -l lastBuild (git describe --tags --abbrev=0 | cut -d'.' -f3)

    set -l regex (string join '' 's/^\(.*\)' $lastBuild '$/\1/')
    set -l prefix (git describe --tags --abbrev=0 | sed $regex)
    set -l nextBuild (math $lastBuild + 1)
    set -l nextTag (string join '' $prefix $nextBuild)

    git add .
    git commit -a -m "tag increment"
    git push
    git tag $nextTag
    git push --tags
end
