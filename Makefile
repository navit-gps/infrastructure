SHELL = /bin/bash
TERRAFORM := $(shell command -v terraform)

Q=@

usage:
	$Qecho 'make [command] service=[service]'

plan: clean
	$Qterraform get -update=true $(CURDIR)/terraform/$(service)/
	$Qcd $(CURDIR)/terraform/$(service) && \
		terraform init \
	      -backend-config=bucket=navit-infrastructure \
		  -backend-config=key=terraform/v1/$(service).tfstate \
		  -reconfigure && \
		terraform plan \
		  -refresh=true \
		  -input=false \
		  -out=$(CURDIR)/terraform/$(service)/$(service).plan

apply:
	$Qcd $(CURDIR)/terraform/$(service) && \
		terraform apply -input=false \
		  ./$(service).plan

clean:
	$Qrm -f $$(find . -name '*.plan')

lint:
	$Qterraform fmt $(CURDIR)/terraform

print-%: ; @echo $*=$($*)

.PHONY: *
