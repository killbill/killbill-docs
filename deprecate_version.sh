if [ "$#" -ne 1 ]
then
  echo "Usage: $0 version"
  exit 1
fi

sed -i '' 's|\<body class="book"\>|\<body class="book"\>\
\<div style="background-color: hsl(353, 100%, 95%); color: #ff0000; position: sticky; top: 0; padding-top: 20px; padding-bottom: 20px; text-align: center; z-index: 10;"\>\
\<strong\>This version of Kill Bill is not supported anymore, please see our \<a href="https://docs.killbill.io"\>latest documentation\</a\>\</strong\>\
\</div\>|' ./$1/*.html
