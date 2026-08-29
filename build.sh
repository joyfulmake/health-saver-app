#!/usr/bin/env bash
set -e
sed -i "s|__RAZORPAY_KEY__|$RAZORPAY_KEY|g" index.html
sed -i "s|__WEB3FORMS_KEY__|$WEB3FORMS_KEY|g" index.html
sed -i "s|__FLOURISH_PRO_KEY__|$FLOURISH_PRO_KEY|g" index.html
python3 -c "import os; cfg=os.environ.get('FIREBASE_CONFIG','').replace('\n','').replace('\r','').replace(' ',''); content=open('index.html').read(); open('index.html','w').write(content.replace('__FIREBASE_CONFIG__',cfg))"
