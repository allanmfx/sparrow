# =============================================================================
# Sparrow - Enterprise Architecture
# Simplified Makefile
# =============================================================================

# Colors
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

# Configuration
ARGOCD_PASSWORD ?= admin123
GRAFANA_PASSWORD ?= admin

.PHONY: help data platform build monitor check clean full destroy

help: ## Show this help
	@echo "Sparrow - Enterprise Architecture"
	@echo "Usage: make [target]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-15s$(NC) %s\n", $$1, $$2}'

# =============================================================================
# DATA INFRASTRUCTURE
# =============================================================================

data: ## Start data infrastructure
	@echo "$(BLUE)🐳 Starting data infrastructure...$(NC)"
	@docker-compose up -d

data-down: ## Stop data infrastructure
	@echo "$(YELLOW)🛑 Stopping data infrastructure...$(NC)"
	@docker-compose down

data-destroy: ## Destroy data infrastructure
	@echo "$(RED)🗑️ Destroying data infrastructure...$(NC)"
	@docker-compose down -v
	@docker system prune -f
	@echo "$(GREEN)✅ Data infrastructure destroyed$(NC)"

logs: ## View data logs
	@docker-compose logs -f

# =============================================================================
# PLATFORM (TERRAFORM)
# =============================================================================

platform: ## Deploy platform
	@echo "$(BLUE)🏗️ Deploying platform...$(NC)"
	@cd infra/terraform/environments/local && terraform init && terraform apply -auto-approve

platform-plan: ## Plan Terraform changes
	@echo "$(BLUE)📋 Planning changes...$(NC)"
	@cd infra/terraform/environments/local && terraform init && terraform plan

platform-destroy: ## Destroy platform
	@echo "$(RED)🗑️ Destroying platform...$(NC)"
	@cd infra/terraform/environments/local && terraform init && terraform destroy -auto-approve
	@rm -rf infra/terraform/environments/local/.terraform
	@rm -rf infra/terraform/environments/local/terraform.tfstate*
	@echo "$(GREEN)✅ Platform destroyed$(NC)"



# =============================================================================
# MONITORING
# =============================================================================

monitor: ## Open monitoring dashboards
	@echo "$(BLUE)📊 Opening dashboards...$(NC)"
	@open http://localhost:30000 || echo "$(YELLOW)Grafana: http://localhost:30000 (admin/$(GRAFANA_PASSWORD))$(NC)"
	@open http://localhost:30080 || echo "$(YELLOW)ArgoCD: http://localhost:30080 (admin/$(ARGOCD_PASSWORD))$(NC)"

check: ## Check environment status
	@echo "$(BLUE)✅ Checking environment...$(NC)"
	@docker-compose ps --format "table {{.Name}}\t{{.Status}}"
	@echo ""
	@kubectl cluster-info 2>/dev/null && echo "$(GREEN)✅ Kubernetes OK$(NC)" || echo "$(RED)❌ Kubernetes not responding$(NC)"

# =============================================================================
# UTILITIES
# =============================================================================

clean: ## Clean everything (soft cleanup)
	@echo "$(YELLOW)🧹 Cleaning everything...$(NC)"
	@docker-compose down -v
	@docker system prune -f
	@rm -rf infra/terraform/environments/local/.terraform
	@rm -rf infra/terraform/environments/local/terraform.tfstate*
	@echo "$(GREEN)✅ Cleanup completed$(NC)"

destroy: ## Destroy everything completely
	@echo "$(RED)🔥 DESTROYING EVERYTHING...$(NC)"
	@echo "$(YELLOW)⚠️ This will destroy ALL infrastructure!$(NC)"
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "$(RED)🗑️ Starting complete destruction...$(NC)"; \
		make platform-destroy; \
		make data-destroy; \
		echo "$(GREEN)✅ Everything destroyed successfully!$(NC)"; \
	else \
		echo "$(YELLOW)❌ Destruction cancelled$(NC)"; \
	fi

full: ## Full setup (data + platform)
	@echo "$(BLUE)🚀 Full setup...$(NC)"
	@make data
	@make platform
	@echo "$(GREEN)✅ Full setup completed!$(NC)"
	@echo "$(BLUE)📊 Access your services:$(NC)"
	@echo "  • Grafana: http://localhost:30000 (admin/$(GRAFANA_PASSWORD))$(NC)"
	@echo "  • ArgoCD: http://localhost:30080 (admin/$(ARGOCD_PASSWORD))$(NC)"
	@echo "  • Prometheus: http://localhost:30001$(NC)"
