if [ "$#" -ne 1 ]
then
  echo "Usage: $0 version"
  exit 1
fi

echo "Reshma 1"

DEPRECATED_CODE="<div style=\"background-color: hsl(353, 100%, 95%); color: #ff0000; position: sticky; top: 0; padding-top: 20px; padding-bottom: 20px; \
text-align: center; z-index: 10;\"><strong>This version of Kill Bill is not supported anymore, please see our \
<a href=\"https://docs.killbill.io\">latest documentation</a></strong></div>"

echo "Reshma DEPRECATED_CODE $DEPRECATED_CODE"

DEPRECATED_CODE_ESCAPED=$(sed 's/[&/\]/\\&/g' <<<"$DEPRECATED_CODE")

echo "Reshma DEPRECATED_CODE_ESCAPED $DEPRECATED_CODE_ESCAPED"


sed -i -e "s/<body.*class=\"book\">/&\n$DEPRECATED_CODE_ESCAPED/g" ./$1/*.html
