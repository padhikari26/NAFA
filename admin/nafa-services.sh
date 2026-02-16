# Colors for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Beautiful banner
show_banner() {
  clear
  printf "${CYAN}${BOLD}"
  printf "╔══════════════════════════════════════════════════════════════════════════════════╗\n"
  printf "║                                                                                  ║\n"
  printf "║    ███╗   ██╗ █████╗ ███████╗ █████╗ ██╗   ██╗███████╗ █████╗                    ║\n"
  printf "║    ████╗  ██║██╔══██╗██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗                   ║\n"
  printf "║    ██╔██╗ ██║███████║█████╗  ███████║██║   ██║███████╗███████║                   ║\n"
  printf "║    ██║╚██╗██║██╔══██║██╔══╝  ██╔══██║██║   ██║╚════██║██╔══██║                   ║\n"
  printf "║    ██║ ╚████║██║  ██║██║     ██║  ██║╚██████╔╝███████║██║  ██║                   ║\n"
  printf "║    ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝                   ║\n"
  printf "║                                                                                  ║\n"
  printf "║                     ${WHITE}Professional Deployment Manager v2.0${CYAN}                         ║\n"
  printf "║                                                                                  ║\n"
  printf "╚══════════════════════════════════════════════════════════════════════════════════╝\n"
  printf "${NC}\n"
  printf "\n"
  printf "${DIM}${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
  printf "\n"
}

# Beautiful project detection display
show_project_detection() {
  local project_type="$1"
  local project_name="$2"
  
  printf "${PURPLE}${BOLD}🔍 PROJECT DETECTION${NC}\n"
  printf "${DIM}────────────────────${NC}\n"
  
  case "$project_name" in
    "nafusa")
      printf "${GREEN}${BOLD}✓${NC} ${WHITE}Project Type:${NC} ${CYAN}Server Backend${NC}\n"
      printf "${GREEN}${BOLD}✓${NC} ${WHITE}Project Name:${NC} ${YELLOW}$project_name${NC}\n"
      printf "${GREEN}${BOLD}✓${NC} ${WHITE}Environment:${NC} ${BLUE}NestJS Production Server${NC}\n"
      ;;
    "nafa-admin")
      printf "${GREEN}${BOLD}✓${NC} ${WHITE}Project Type:${NC} ${PURPLE}Admin Dashboard${NC}\n"
      printf "${GREEN}${BOLD}✓${NC} ${WHITE}Project Name:${NC} ${YELLOW}$project_name${NC}\n"
      printf "${GREEN}${BOLD}✓${NC} ${WHITE}Environment:${NC} ${BLUE}React Admin Panel${NC}\n"
      ;;
  esac
  
  printf "\n"
}

# Beautiful menu display
show_professional_menu() {
  local project_name="$1"
  
  printf "${CYAN}${BOLD}⚡ DEPLOYMENT OPTIONS${NC}\n"
  printf "${DIM}─────────────────────${NC}\n"
  printf "\n"
  
  case "$project_name" in
    "nafusa")
      printf "${WHITE}${BOLD}🚀 DEPLOYMENT${NC}\n"
      printf "  ${GREEN}1.${NC} ${WHITE}Deploy Server + Restart Service${NC}    ${DIM}(Full production deployment)${NC}\n"
      printf "  ${GREEN}2.${NC} ${WHITE}Deploy Server Only${NC}              ${DIM}(Build without service restart)${NC}\n"
      printf "\n"
      printf "${WHITE}${BOLD}⚙️  SYSTEM OPERATIONS${NC}\n"
      printf "  ${BLUE}3.${NC} ${WHITE}Restart Services${NC}                ${DIM}(Refresh all services)${NC}\n"
      printf "  ${BLUE}4.${NC} ${WHITE}Backup Uploads${NC}                  ${DIM}(Safe copy user uploads)${NC}\n"
      printf "\n"
      printf "${WHITE}${BOLD}💾 BACKUP & RESTORE${NC}\n"
      printf "  ${YELLOW}5.${NC} ${WHITE}Create Server Backup${NC}            ${DIM}(Manual safety checkpoint)${NC}\n"
      printf "  ${RED}6.${NC} ${WHITE}Rollback Server${NC}                 ${DIM}(Restore previous version)${NC}\n"
      printf "\n"
      printf "  ${DIM}7.${NC} ${DIM}Exit${NC}\n"
      ;;
    "nafa-admin")
      printf "${WHITE}${BOLD}🚀 DEPLOYMENT${NC}\n"
      printf "  ${GREEN}1.${NC} ${WHITE}Deploy Admin + Restart Service${NC}   ${DIM}(Full production deployment)${NC}\n"
      printf "  ${GREEN}2.${NC} ${WHITE}Deploy Admin Only${NC}               ${DIM}(Build without service restart)${NC}\n"
      printf "\n"
      printf "${WHITE}${BOLD}⚙️  SYSTEM OPERATIONS${NC}\n"
      printf "  ${BLUE}3.${NC} ${WHITE}Restart Services${NC}                ${DIM}(Refresh all services)${NC}\n"
      printf "\n"
      printf "${WHITE}${BOLD}💾 BACKUP & RESTORE${NC}\n"
      printf "  ${YELLOW}4.${NC} ${WHITE}Create Admin Backup${NC}             ${DIM}(Manual safety checkpoint)${NC}\n"
      printf "  ${RED}5.${NC} ${WHITE}Rollback Admin${NC}                  ${DIM}(Restore previous version)${NC}\n"
      printf "\n"
      printf "  ${DIM}6.${NC} ${DIM}Exit${NC}\n"
      ;;
  esac
  
  printf "\n"
  printf "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
  printf "\n"
}

# Enhanced input prompt
get_user_choice() {
  printf "${CYAN}${BOLD}➤${NC} ${WHITE}Select option:${NC} "
  read choice
  printf "\n"
}

# Confirmation prompt for operations
confirm_operation() {
  local operation_name="$1"
  local operation_desc="$2"
  local warning_msg="$3"
  
  printf "\n"
  printf "${YELLOW}${BOLD}⚠️  OPERATION CONFIRMATION${NC}\n"
  printf "${DIM}═══════════════════════════${NC}\n"
  printf "\n"
  printf "${WHITE}${BOLD}Operation:${NC} ${CYAN}$operation_name${NC}\n"
  printf "${WHITE}${BOLD}Description:${NC} $operation_desc\n"
  
  if [ -n "$warning_msg" ]; then
    printf "\n"
    printf "${RED}${BOLD}⚠️  Warning:${NC} $warning_msg\n"
  fi
  
  printf "\n"
  printf "${DIM}────────────────────────────────────────────────${NC}\n"
  printf "${YELLOW}${BOLD}➤${NC} ${WHITE}Type 'yes' to confirm or 'no' to cancel:${NC} "
  read confirm
  
  if [ "$confirm" != "yes" ]; then
    printf "\n"
    printf "${GREEN}${BOLD}✅ Operation cancelled.${NC}\n"
    printf "\n"
    return 1
  fi
  
  printf "\n"
  printf "${BLUE}${BOLD}🚀 PROCEEDING WITH OPERATION${NC}\n"
  printf "${DIM}════════════════════════════${NC}\n"
  printf "\n"
  return 0
}

PEM_KEY="$HOME/.ssh/nafausa-ssh.pem"
SERVER_USER="bitnami"
SERVER_IP="3.88.254.79"


# Enhanced backup with professional styling
backup_uploads() {
  if ! confirm_operation "Backup Uploads" "Create a backup copy of all user uploaded files" "This will replace any existing uploads backup"; then
    return 0
  fi
  
  printf "${YELLOW}${BOLD}💾 BACKUP UPLOADS${NC}\n"
  printf "${DIM}═══════════════════${NC}\n"
  printf "\n"
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Check if uploads directory exists
    if [ ! -d "nafausa-server/uploads" ]; then
      echo "❌ Error: nafausa-server/uploads directory does not exist"
      exit 1
    fi
    
    # Create uploads_backup directory
    mkdir -p uploads_backup
    
    # Check if uploads_backup already has content and remove it
    if [ -d "uploads_backup" ] && [ "$(ls -A uploads_backup)" ]; then
      echo "🧹 Clearing existing uploads_backup directory..."
      rm -rf uploads_backup/*
    fi
    
    # Copy contents of uploads directory to uploads_backup
    echo "📂 Copying uploads to backup location..."
    cp -r nafausa-server/uploads/* uploads_backup/
    echo "✅ Backup completed: uploads → uploads_backup/"
EOF
  
  printf "\n"
  printf "${GREEN}${BOLD}🎉 Uploads backup completed successfully!${NC}\n"
  printf "\n"
}

# Enhanced restart service with professional styling
# Enhanced restart service with professional styling
restart_service() {
  if ! confirm_operation "Restart Services" "Restart all NAFAUSA services (server and admin)" "This will temporarily stop services causing brief downtime"; then
    return 0
  fi
  
  printf "${BLUE}${BOLD}🔄 RESTARTING SERVICES${NC}\n"
  printf "${DIM}═════════════════════${NC}\n"
  printf "\n"
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    echo "🛑 Stopping nafausa-all service..."
    sudo systemctl stop nafausa-all
    sleep 3
    echo "🔧 Reloading daemon configuration..."
    sudo systemctl daemon-reload
    echo "⚡ Enabling nafausa-all service..."
    sudo systemctl enable nafausa-all
    echo "🚀 Starting nafausa-all service..."
    sudo systemctl start nafausa-all
EOF
  
  printf "\n"
  printf "${GREEN}${BOLD}✅ Service restart completed!${NC}\n"
  printf "\n"
}

# Transfer server files and restart
transfer_server() {
  if ! confirm_operation "Deploy Server + Restart" "Full production deployment with automatic backup and service restart" "This will update production server and restart services"; then
    return 0
  fi
  
  validate_server_directory
  
  # Create backup before deployment
  create_server_backup
  
  printf "${BLUE}${BOLD}📦 TRANSFERRING SERVER FILES${NC}\n"
  printf "${DIM}══════════════════════════════${NC}\n"
  printf "\n"
  
  rm -rf uploads
  rm -rf logs
  rsync -avz \
    --exclude 'node_modules' \
    --exclude '.next' \
    --exclude 'uploads' \
    --exclude '.env' \
    --exclude 'dist' \
    --exclude 'logs' \
    --exclude '.git' \
    -e "ssh -i $PEM_KEY" \
    . $SERVER_USER@$SERVER_IP:~/nafausa-server

  # Validate transfer
  if ! validate_transfer "nafausa-server"; then
    printf "${RED}Transfer failed validation. Rolling back...${NC}\n"
    rollback_server
    exit 1
  fi

  printf "${BLUE}${BOLD}🔨 BUILDING AND RESTARTING SERVER${NC}\n"
  printf "${DIM}═══════════════════════════════════${NC}\n"
  printf "\n"
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    cd nafausa-server
    echo "📦 Installing dependencies..."
    pnpm install
    echo "🔨 Building server..."
    npm run build
    echo "🔄 Restarting services..."
    sudo systemctl stop nafausa-all
    sleep 3
    sudo systemctl daemon-reload
    sudo systemctl enable nafausa-all
    sudo systemctl start nafausa-all
EOF

  # Health check after restart
  sleep 5  # Give service time to start
  if ! health_check_server; then
    printf "${RED}Deployment failed health check. Rolling back...${NC}\n"
    rollback_server
    exit 1
  fi
  
  printf "\n"
  printf "${GREEN}${BOLD}🎉 Server deployment completed successfully!${NC}\n"
  printf "\n"
}

# Transfer server files without restart
transfer_server_no_restart() {
  if ! confirm_operation "Deploy Server Only" "Build and transfer server files without restarting services" "Services will not be restarted - changes may not be active until manual restart"; then
    return 0
  fi
  
  validate_server_directory
  
  printf "${BLUE}${BOLD}📦 TRANSFERRING SERVER FILES${NC}\n"
  printf "${DIM}══════════════════════════════${NC}\n"
  printf "\n"
  
  rm -rf uploads
  rm -rf logs
  rsync -avz \
    --exclude 'node_modules' \
    --exclude '.next' \
    --exclude 'uploads' \
    --exclude '.env' \
    --exclude 'dist' \
    --exclude 'logs' \
    --exclude '.git' \
    -e "ssh -i $PEM_KEY" \
    . $SERVER_USER@$SERVER_IP:~/nafausa-server

  # Validate transfer
  if ! validate_transfer "nafausa-server"; then
    printf "${RED}Transfer failed validation. Aborting build.${NC}\n"
    exit 1
  fi

  printf "${BLUE}${BOLD}🔨 BUILDING SERVER${NC}\n"
  printf "${DIM}═══════════════════${NC}\n"
  printf "\n"
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    cd nafausa-server
    echo "📦 Installing dependencies..."
    pnpm install
    echo "🔨 Building server..."
    npm run build
EOF

  # Validate build output
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    if [ ! -d "nafausa-server/dist" ] && [ ! -d "nafausa-server/build" ]; then
      echo "❌ Error: Build failed - no build output found"
      exit 1
    fi
    echo "✅ Build validation passed."
EOF
  
  if [ $? -ne 0 ]; then
    printf "${RED}Build failed validation.${NC}\n"
    exit 1
  fi
  
  printf "\n"
  printf "${GREEN}${BOLD}🎉 Server build completed successfully!${NC}\n"
  printf "${YELLOW}${BOLD}ℹ️  Note: Services not restarted. Use option 3 to restart services.${NC}\n"
  printf "\n"
}

# Enhanced server backup with professional styling
create_server_backup() {
  if ! confirm_operation "Create Server Backup" "Create a timestamped backup of the entire server codebase" "This will create a safety checkpoint before making changes"; then
    return 0
  fi

  printf "${YELLOW}${BOLD}💾 CREATING SERVER BACKUP${NC}\n"
  printf "${DIM}═══════════════════════════${NC}\n"
  printf "\n"

  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Create backup directory with timestamp
    backup_dir="nafausa-server-backup-$(date +%Y%m%d-%H%M%S)"

    # Check if server directory exists
    if [ -d "nafausa-server" ]; then
      echo "� Creating backup: \$backup_dir"
      # Use rsync to exclude dist and node_modules
      rsync -a --exclude 'dist' --exclude 'node_modules' nafausa-server/ "\$backup_dir/"
      echo "✅ Server backup created successfully"
    else
      echo "⚠️  No existing server directory to backup"
      exit 1
    fi

    # Keep only last 2 backups
    echo "🧹 Managing backup retention (keeping last 2)..."
    ls -dt nafausa-server-backup-* 2>/dev/null | tail -n +3 | xargs rm -rf

    echo ""
    echo "📋 Available backups:"
    ls -dt nafausa-server-backup-* 2>/dev/null | while read backup; do
      echo "   └─ \$backup"
    done
EOF

  if [ $? -eq 0 ]; then
    printf "\n"
    printf "${GREEN}${BOLD}🎉 Server backup completed successfully!${NC}\n"
  else
    printf "\n"
    printf "${RED}${BOLD}❌ Server backup failed!${NC}\n"
    exit 1
  fi
  printf "\n"
}

# Enhanced admin backup with professional styling
create_admin_backup() {
  if ! confirm_operation "Create Admin Backup" "Create a timestamped backup of the entire admin panel codebase" "This will create a safety checkpoint before making changes"; then
    return 0
  fi
  
  printf "${YELLOW}${BOLD}💾 CREATING ADMIN BACKUP${NC}\n"
  printf "${DIM}══════════════════════════${NC}\n"
  printf "\n"
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Create backup directory with timestamp
    backup_dir="nafausa-admin-backup-$(date +%Y%m%d-%H%M%S)"
    
    # Check if admin directory exists
    if [ -d "nafausa-admin" ]; then
      echo "� Creating backup: \$backup_dir"
      # Use rsync to exclude .next and node_modules
      rsync -a --exclude '.next' --exclude 'node_modules' nafausa-admin/ "\$backup_dir/"
      echo "✅ Admin backup created successfully"
    else
      echo "⚠️  No existing admin directory to backup"
      exit 1
    fi
    
    # Keep only last 2 backups
    echo "🧹 Managing backup retention (keeping last 2)..."
    ls -dt nafausa-admin-backup-* 2>/dev/null | tail -n +3 | xargs rm -rf
    
    echo ""
    echo "📋 Available backups:"
    ls -dt nafausa-admin-backup-* 2>/dev/null | while read backup; do
      echo "   └─ \$backup"
    done
EOF

  if [ $? -eq 0 ]; then
    printf "\n"
    printf "${GREEN}${BOLD}🎉 Admin backup completed successfully!${NC}\n"
  else
    printf "\n"
    printf "${RED}${BOLD}❌ Admin backup failed!${NC}\n"
    exit 1
  fi
  printf "\n"
}

# Enhanced rollback confirmations with professional styling
rollback_server() {
  echo ""
  echo -e "${RED}${BOLD}⚠️  SERVER ROLLBACK CONFIRMATION${NC}"
  echo -e "${RED}════════════════════════════════${NC}"
  echo ""
  echo -e "${YELLOW}🔄 This will rollback the server to the previous backup${NC}"
  echo ""
  echo -e "${WHITE}${BOLD}📋 Effects of this action:${NC}"
  echo -e "   ${RED}•${NC} Current server code will be ${RED}${BOLD}DELETED${NC}"
  echo -e "   ${RED}•${NC} Previous backup will be restored"
  echo -e "   ${RED}•${NC} All recent changes since last backup will be ${RED}${BOLD}LOST${NC}"
  echo -e "   ${RED}•${NC} Server service will be restarted"
  echo -e "   ${RED}•${NC} Any new files/changes will be permanently removed"
  echo ""
  echo -e "${RED}${BOLD}⚠️  WARNING: This action cannot be undone!${NC}"
  echo ""
  echo -e "${DIM}────────────────────────────────────────────────${NC}"
  echo -ne "${RED}${BOLD}➤${NC} ${WHITE}Type 'yes' to confirm rollback:${NC} "
  read confirm
  
  if [ "$confirm" != "yes" ]; then
    echo ""
    echo -e "${GREEN}${BOLD}✅ Server rollback cancelled.${NC}"
    echo ""
    exit 0
  fi
  
  echo ""
  echo -e "${BLUE}${BOLD}🔄 PROCEEDING WITH SERVER ROLLBACK${NC}"
  echo -e "${DIM}═══════════════════════════════════${NC}"
  echo ""
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Find the most recent backup
    latest_backup=$(ls -dt nafausa-server-backup-* 2>/dev/null | head -1)
    
    if [ -z "$latest_backup" ]; then
      echo "❌ Error: No server backup found for rollback"
      exit 1
    fi
    
    echo "📦 Rolling back to: $latest_backup"
    
    # Remove current server directory
    echo "🗑️  Removing current server directory..."
    rm -rf nafausa-server
    
    # Restore from backup
    echo "📥 Restoring from backup..."
    cp -r "$latest_backup" nafausa-server
    
    # Restart service
    echo "🔄 Restarting services..."
    sudo systemctl stop nafausa-all
    sleep 3
    sudo systemctl daemon-reload
    sudo systemctl enable nafausa-all
    sudo systemctl start nafausa-all
    
    echo "✅ Server rollback completed"
EOF

  if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}${BOLD}🎉 Server rollback completed successfully!${NC}"
  else
    echo ""
    echo -e "${RED}${BOLD}❌ Server rollback failed!${NC}"
    exit 1
  fi
  echo ""
}

# Enhanced admin rollback with professional styling
rollback_admin() {
  echo ""
  echo -e "${RED}${BOLD}⚠️  ADMIN ROLLBACK CONFIRMATION${NC}"
  echo -e "${RED}═══════════════════════════════${NC}"
  echo ""
  echo -e "${YELLOW}🔄 This will rollback the admin panel to the previous backup${NC}"
  echo ""
  echo -e "${WHITE}${BOLD}📋 Effects of this action:${NC}"
  echo -e "   ${RED}•${NC} Current admin panel code will be ${RED}${BOLD}DELETED${NC}"
  echo -e "   ${RED}•${NC} Previous backup will be restored"
  echo -e "   ${RED}•${NC} All recent changes since last backup will be ${RED}${BOLD}LOST${NC}"
  echo -e "   ${RED}•${NC} Admin service will be restarted"
  echo -e "   ${RED}•${NC} Any new features/fixes will be permanently removed"
  echo ""
  echo -e "${RED}${BOLD}⚠️  WARNING: This action cannot be undone!${NC}"
  echo ""
  echo -e "${DIM}────────────────────────────────────────────────${NC}"
  echo -ne "${RED}${BOLD}➤${NC} ${WHITE}Type 'yes' to confirm rollback:${NC} "
  read confirm
  
  if [ "$confirm" != "yes" ]; then
    echo ""
    echo -e "${GREEN}${BOLD}✅ Admin rollback cancelled.${NC}"
    echo ""
    exit 0
  fi
  
  echo ""
  echo -e "${BLUE}${BOLD}🔄 PROCEEDING WITH ADMIN ROLLBACK${NC}"
  echo -e "${DIM}══════════════════════════════════${NC}"
  echo ""
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Find the most recent backup
    latest_backup=$(ls -dt nafausa-admin-backup-* 2>/dev/null | head -1)
    
    if [ -z "$latest_backup" ]; then
      echo "❌ Error: No backup found for rollback"
      exit 1
    fi
    
    echo "📦 Rolling back to: $latest_backup"
    
    # Remove current admin directory
    echo "🗑️  Removing current admin directory..."
    rm -rf nafausa-admin
    
    # Restore from backup
    echo "📥 Restoring from backup..."
    cp -r "$latest_backup" nafausa-admin
    
    # Restart service
    echo "🔄 Restarting services..."
    sudo systemctl stop nafausa-all
    sleep 3
    sudo systemctl daemon-reload
    sudo systemctl enable nafausa-all
    sudo systemctl start nafausa-all
    
    echo "✅ Admin rollback completed"
EOF

  if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}${BOLD}🎉 Admin rollback completed successfully!${NC}"
  else
    echo ""
    echo -e "${RED}${BOLD}❌ Admin rollback failed!${NC}"
    exit 1
  fi
  echo ""
}

# Health check for server
health_check_server() {
  echo "Performing server health check..."
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Check if server build was successful
    if [ ! -d "nafausa-server/dist" ] && [ ! -d "nafausa-server/build" ]; then
      echo "Error: No build output found in nafausa-server directory"
      exit 1
    fi
    
    # Check if node_modules exists
    if [ ! -d "nafausa-server/node_modules" ]; then
      echo "Error: node_modules not found - dependencies may not be installed"
      exit 1
    fi
    
    # Check if the service is running
    if ! sudo systemctl is-active --quiet nafausa-all; then
      echo "Error: nafausa-all service is not running"
      sudo systemctl status nafausa-all
      exit 1
    fi
    
    echo "Server health check passed."
EOF
  
  if [ $? -ne 0 ]; then
    echo "Server health check failed!"
    return 1
  fi
  
  echo "Server is healthy."
  return 0
}

# Health check for admin panel
health_check_admin() {
  echo "Performing admin panel health check..."
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    # Check if admin build was successful
    if [ ! -d "nafausa-admin/.next" ] && [ ! -d "nafausa-admin/dist" ] && [ ! -d "nafausa-admin/build" ]; then
      echo "Error: No build output found in nafausa-admin directory"
      exit 1
    fi
    
    # Check if the service is running
    if ! sudo systemctl is-active --quiet nafausa-all; then
      echo "Error: nafausa-all service is not running"
      sudo systemctl status nafausa-all
      exit 1
    fi
    
    echo "Admin panel health check passed."
EOF
  
  if [ $? -ne 0 ]; then
    echo "Admin panel health check failed!"
    return 1
  fi
  
  echo "Admin panel is healthy."
  return 0
}

# Validate transfer success
validate_transfer() {
  local target_dir=$1
  echo "Validating transfer to $target_dir..."
  
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << EOF
    # Check if target directory exists
    if [ ! -d "$target_dir" ]; then
      echo "Error: Target directory $target_dir does not exist on server"
      exit 1
    fi
    
    # Check if package.json was transferred
    if [ ! -f "$target_dir/package.json" ]; then
      echo "Error: package.json not found in $target_dir"
      exit 1
    fi
    
    # Check if we can read the directory
    file_count=\$(find "$target_dir" -type f | wc -l)
    if [ "\$file_count" -lt 5 ]; then
      echo "Warning: Only \$file_count files found in $target_dir. Transfer may be incomplete."
      exit 1
    fi
    
    echo "Transfer validation passed. Found \$file_count files in $target_dir"
EOF
  
  if [ $? -ne 0 ]; then
    echo "Transfer validation failed!"
    return 1
  fi
  
  echo "Transfer validation successful."
  return 0
}

# Validate server directory
validate_server_directory() {
  echo "Validating server directory..."
  
  # Check for essential server files
  if [ ! -f "package.json" ]; then
    echo "Error: package.json not found. Are you in the correct project directory?"
    exit 1
  fi
  
  # Check package.json name field to determine if this is a server project
  project_name=$(grep '"name"' package.json | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  
  if [ "$project_name" != "nafusa" ]; then
    echo "Error: This appears to be '$project_name' project, not a server project."
    echo "Expected package.json name: 'nafusa' for server"
    echo "Found package.json name: '$project_name'"
    exit 1
  fi
  
  echo "✓ Confirmed: This is the server project (nafusa)"
  
  # Check for main server file
  if [ ! -f "src/main.ts" ] && [ ! -f "src/index.ts" ] && [ ! -f "src/app.ts" ] && [ ! -f "index.js" ]; then
    echo "Warning: No main server file found (main.ts, index.ts, app.ts, or index.js)"
    read -p "Continue anyway? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "Transfer cancelled."
      exit 1
    fi
  fi
  
  echo "Server directory validation passed."
}

# Validate admin directory
validate_admin_directory() {
  echo "Validating admin directory..."
  
  # Check for essential admin files
  if [ ! -f "package.json" ]; then
    echo "Error: package.json not found. Are you in the correct project directory?"
    exit 1
  fi
  
  # Check package.json name field to determine if this is an admin project
  project_name=$(grep '"name"' package.json | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  
  if [ "$project_name" != "nafa-admin" ]; then
    echo "Error: This appears to be '$project_name' project, not an admin project."
    echo "Expected package.json name: 'nafa-admin' for admin panel"
    echo "Found package.json name: '$project_name'"
    exit 1
  fi
  
  echo "✓ Confirmed: This is the admin panel project (nafa-admin)"
  
  echo "Admin directory validation passed."
}

# Transfer admin files and restart
transfer_admin() {
  if ! confirm_operation "Deploy Admin Panel" "Deploy admin panel with automatic service restart" "This will update the live admin panel and restart all services"; then
    return 0
  fi
  
  validate_admin_directory
  
  # Create backup before deployment
  create_admin_backup
  
  echo "Transferring admin files..."
  rsync -avz \
    --exclude 'node_modules' \
    --exclude '.next' \
    --exclude 'logs' \
    --exclude '.git' \
    -e "ssh -i $PEM_KEY" \
    . $SERVER_USER@$SERVER_IP:~/nafausa-admin

  # Validate transfer
  if ! validate_transfer "nafausa-admin"; then
    echo "Transfer failed validation. Rolling back..."
    rollback_admin
    exit 1
  fi

  echo "Build and restart admin..."
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    cd nafausa-admin
    pnpm install
    npm run build
    sudo systemctl stop nafausa-all
    sleep 3
    sudo systemctl daemon-reload
    sudo systemctl enable nafausa-all
    sudo systemctl start nafausa-all
EOF

  # Health check after restart
  sleep 5  # Give service time to start
  if ! health_check_admin; then
    echo "Deployment failed health check. Rolling back..."
    rollback_admin
    exit 1
  fi
  
  echo "Admin deployment completed successfully!"
}

# Transfer admin files without restart
transfer_admin_no_restart() {
  if ! confirm_operation "Build Admin Panel" "Deploy and build admin panel without restarting services" "This will update admin code but services will continue running"; then
    return 0
  fi
  
  validate_admin_directory
  
  echo "Transferring admin files (no restart)..."
  rsync -avz \
    --exclude 'node_modules' \
    --exclude '.next' \
    --exclude 'logs' \
    --exclude '.git' \
    -e "ssh -i $PEM_KEY" \
    . $SERVER_USER@$SERVER_IP:~/nafausa-admin

  # Validate transfer
  if ! validate_transfer "nafausa-admin"; then
    echo "Transfer failed validation. Aborting build."
    exit 1
  fi

  echo "Build admin (no restart)..."
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    cd nafausa-admin
    pnpm install
    npm run build
EOF

  # Validate build output
  ssh -i "$PEM_KEY" $SERVER_USER@$SERVER_IP << 'EOF'
    if [ ! -d "nafausa-admin/.next" ] && [ ! -d "nafausa-admin/dist" ] && [ ! -d "nafausa-admin/build" ]; then
      echo "Error: Build failed - no build output found"
      exit 1
    fi
    echo "Build validation passed."
EOF
  
  if [ $? -ne 0 ]; then
    echo "Build failed validation."
    exit 1
  fi
  
  echo "Admin build completed successfully!"
}

# Auto-detect project type based on package.json
detect_project_type() {
  if [ ! -f "package.json" ]; then
    return 1
  fi
  
  project_name=$(grep '"name"' package.json | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  
  case "$project_name" in
    "nafusa")
      show_project_detection "server" "$project_name"
      return 0
      ;;
    "nafa-admin")
      show_project_detection "admin" "$project_name"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Enhanced error display for unknown projects
show_unknown_project_error() {
  local project_name="$1"
  
  printf "${RED}${BOLD}❌ UNKNOWN PROJECT DETECTED${NC}\n"
  printf "${DIM}═══════════════════════════${NC}\n"
  printf "\n"
  printf "${WHITE}Current package.json name:${NC} ${YELLOW}$project_name${NC}\n"
  printf "\n"
  printf "${GREEN}${BOLD}✅ Expected project names:${NC}\n"
  printf "   ${GREEN}•${NC} ${CYAN}'nafusa'${NC} - for server project\n"
  printf "   ${GREEN}•${NC} ${PURPLE}'nafa-admin'${NC} - for admin panel project\n"
  printf "\n"
  printf "${BLUE}${BOLD}🔧 To fix this:${NC}\n"
  printf "   ${BLUE}1.${NC} Open ${WHITE}package.json${NC} in your project\n"
  printf "   ${BLUE}2.${NC} Update the ${WHITE}'name'${NC} field to either:\n"
  printf "      ${DIM}•${NC} ${CYAN}\"nafusa\"${NC} (for server)\n"
  printf "      ${DIM}•${NC} ${PURPLE}\"nafa-admin\"${NC} (for admin panel)\n"
  printf "   ${BLUE}3.${NC} Save the file and run this script again\n"
  printf "\n"
  printf "${YELLOW}📁 Or navigate to the correct project directory${NC}\n"
  printf "\n"
  printf "${DIM}────────────────────────────────────────────────${NC}\n"
  printf "${RED}${BOLD}Script terminated.${NC} Please fix the project name and try again.\n"
  printf "\n"
}

# Enhanced error display for missing package.json
show_missing_package_error() {
  printf "${RED}${BOLD}❌ NO PACKAGE.JSON FOUND${NC}\n"
  printf "${DIM}═════════════════════════${NC}\n"
  printf "\n"
  printf "${BLUE}${BOLD}🔧 To fix this:${NC}\n"
  printf "   ${BLUE}1.${NC} Make sure you're in the correct project directory\n"
  printf "   ${BLUE}2.${NC} Verify the directory contains a ${WHITE}package.json${NC} file\n"
  printf "   ${BLUE}3.${NC} If you're in the right place, check if package.json exists\n"
  printf "\n"
  printf "${GREEN}${BOLD}📁 Expected project structure:${NC}\n"
  printf "   ${GREEN}•${NC} Server project: package.json with ${CYAN}\"name\": \"nafusa\"${NC}\n"
  printf "   ${GREEN}•${NC} Admin project: package.json with ${PURPLE}\"name\": \"nafa-admin\"${NC}\n"
  printf "\n"
  printf "${DIM}────────────────────────────────────────────────${NC}\n"
  printf "${RED}${BOLD}Script terminated.${NC} Please navigate to the correct directory.\n"
  printf "\n"
}

# Show menu based on project type
show_menu() {
  local project_name=$(grep '"name"' package.json | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  
  case "$project_name" in
    "nafusa")
      show_professional_menu "$project_name"
      get_user_choice
      
      case $choice in
        1) transfer_server ;;
        2) transfer_server_no_restart ;;
        3) restart_service ;;
        4) backup_uploads ;;
        5) create_server_backup ;;
        6) rollback_server ;;
        7) printf "${DIM}Goodbye! 👋${NC}\n" ;;
        *) printf "${RED}❌ Invalid choice.${NC}\n" ;;
      esac
      ;;
    "nafa-admin")
      show_professional_menu "$project_name"
      get_user_choice
      
      case $choice in
        1) transfer_admin ;;
        2) transfer_admin_no_restart ;;
        3) restart_service ;;
        4) create_admin_backup ;;
        5) rollback_admin ;;
        6) printf "${DIM}Goodbye! 👋${NC}\n" ;;
        *) printf "${RED}❌ Invalid choice.${NC}\n" ;;
      esac
      ;;
    *)
      show_unknown_project_error "$project_name"
      exit 1
      ;;
  esac
}

# Main execution with enhanced styling
show_banner

# Auto-detect current project
if detect_project_type; then
  printf "\n"
  show_menu
else
  show_missing_package_error
  exit 1
fi