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
	@open https://www.benfletcher.com
