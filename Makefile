# Setup environment variables
sinclude .env
export $(shell [ -f .env ] && sed 's/=.*//' .env)

# ./node_modules/.bin on the PATH
export PATH := ./node_modules/.bin:$(PATH)

test:
	@echo "no test"

deploy:
	@serverless deploy --verbose --region eu-west-1 --stage prod
	@$(MAKE) sync

info:
	@serverless info --verbose --region eu-west-1 --stage prod

sync:
	@aws s3 sync static/ s3://$(BF_BUCKET_NAME)-prod/

open-s3:
	@open http://$(BF_BUCKET_NAME)-prod.s3.amazonaws.com

open:
	@open https://www.benfletcher.com/index.html

# if you want a faster develop-deploy cycle then use this instead
provision-function-only:
	@serverless deploy function --region eu-west-1 --stage dev --function terp-email

logs:
	@serverless logs --region eu-west-1 --stage dev --function terp-email --tail

invoke:
	@serverless invoke --region eu-west-1 --stage dev --function terp-email --data '{}'

invoke-local:
	@serverless invoke local --region eu-west-1 --stage dev --function terp-email --data '{}'
