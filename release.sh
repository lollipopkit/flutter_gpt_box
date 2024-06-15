dart run fl_build -bp
git add . && git commit -s -m "chore: bump version" && git push
git_tag_push

# Usage: git_tag_push [tag] [message]
function git_tag_push {
    # If $1 is empty, use git commit count as the tag
    tag=""
    if [ -z "$1" ]; then
        count=$(git rev-list --count HEAD)
        tag="v1.0.$count"
    else
        tag=$1
    fi
    # If $2 is empty, then use tag as the message
    msg=$tag
    if [ -n "$2" ]; then
        msg=$2
    fi
    git tag -a $tag -m "$msg"
    git push origin $tag
}