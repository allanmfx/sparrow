# =============================================================================
# Sparrow Platform - Professional Makefile
# =============================================================================

.PHONY: help init plan apply destroy full clean status logs test port-forward

# Default target
help:
	@echo "Sparrow Platform - Professional Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  init         - Initialize Terraform"
	@echo "  plan         - Plan Terraform changes"
	@echo "  apply        - Apply Terraform changes"
	@echo "  destroy      - Destroy all infrastructure"
	@echo "  full         - Full deployment (init + apply)"
	@echo "  clean        - Clean up local files"
	@echo "  status       - Check platform status"
	@echo "  logs         - View application logs"
	@echo "  test         - Test platform functionality"
	@echo "  port-forward - Start port-forward for all services"

# Initialize Terraform
init:
	@echo "🏗️ Initializing Terraform..."
	cd infra/terraform/environments/local && terraform init -upgrade

# Plan Terraform changes
plan:
	@echo "📋 Planning Terraform changes..."
	cd infra/terraform/environments/local && terraform plan

# Apply Terraform changes
apply:
	@echo "🚀 Applying Terraform changes..."
	cd infra/terraform/environments/local && terraform apply -auto-approve

# Destroy all infrastructure
destroy:
	@echo "🗑️ Destroying infrastructure..."
	cd infra/terraform/environments/local && terraform destroy -auto-approve

# Full deployment
full: init apply
	@echo "✅ Full deployment completed!"

# Clean up local files
clean:
	@echo "🧹 Cleaning up local files..."
	cd infra/terraform/environments/local && rm -rf .terraform .terraform.lock.hcl
	@echo "✅ Cleanup completed!"

# Check platform status
status:
	@echo "📊 Checking platform status..."
	@echo ""
	@echo "🔍 Kubernetes pods:"
	kubectl get pods -n argocd
	@echo ""
	kubectl get pods -n monitoring
	@echo ""
	@echo "🌐 Services:"
	kubectl get svc -n argocd
	@echo ""
	kubectl get svc -n monitoring

# View application logs
logs:
	@echo "📝 Viewing application logs..."
	@echo "Press Ctrl+C to exit"
	kubectl logs -f -n monitoring -l app.kubernetes.io/name=loki

# Start port-forward for all services
port-forward:
	@echo "🌐 Starting port-forward for all services..."
	@echo "Grafana: http://localhost:30000 (admin/admin)"
	@echo "ArgoCD:  http://localhost:30080 (admin/argocd)"
	@echo "Loki:    http://localhost:3100"
	@echo ""
	@echo "Press Ctrl+C to stop all port-forwards"
	kubectl port-forward -n monitoring svc/prometheus-grafana 30000:80 &
	kubectl port-forward -n argocd svc/argocd-server 30080:443 &
	kubectl port-forward -n monitoring svc/loki 3100:3100 &
	wait

# Test platform functionality
test:
	@echo "🧪 Testing platform functionality..."
	@echo ""
	@echo "1. Testing Loki connectivity..."
	kubectl port-forward -n monitoring svc/loki 3100:3100 &
	@sleep 3
	@curl -H "Content-Type: application/json" -XPOST -s "http://127.0.0.1:3100/loki/api/v1/push" \
		--data-raw '{"streams": [{"stream": {"job": "test", "cluster": "sparrow-local"}, "values": [["'$$(date +%s)'000000000", "Test log from Sparrow platform!"]]}]}' || echo "❌ Loki test failed"
	@echo ""
	@echo "2. Testing Grafana connectivity..."
	kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80 &
	@sleep 3
	@curl -s http://127.0.0.1:3000 | grep -q "Grafana" && echo "✅ Grafana is accessible" || echo "❌ Grafana test failed"
	@echo ""
	@echo "3. Testing ArgoCD connectivity..."
	kubectl port-forward -n argocd svc/argocd-server 8080:443 &
	@sleep 3
	@curl -k -s https://127.0.0.1:8080 | grep -q "Argo CD" && echo "✅ ArgoCD is accessible" || echo "❌ ArgoCD test failed"
	@echo ""
	@echo "🎉 Platform testing completed!"

# Platform deployment (alias for full)
platform: full
