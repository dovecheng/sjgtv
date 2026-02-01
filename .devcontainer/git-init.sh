#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 输出函数
print_header() {
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${WHITE}                    🚀 开发容器初始化脚本 🚀                  ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────┘${NC}"
    echo
}

print_step() {
    echo -e "${BLUE}┌─ ${WHITE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}└─ ✅ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}└─ ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}└─ ⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}└─ ❌ $1${NC}"
}

# 开发容器初始化脚本
print_header

# 获取当前项目目录名
PROJECT_DIR="/workspaces/$(basename "$(dirname "$(dirname "$(realpath "$0")")")")"
print_step "检测项目目录"
print_info "项目路径: $PROJECT_DIR"

# 赋予权限
print_step "设置目录权限"
# 获取当前用户和组
CURRENT_USER=$(whoami)
CURRENT_GROUP=$(id -gn)
# 移除 sudo 命令，因为容器内通常不需要
chown -R $CURRENT_USER:$CURRENT_GROUP /home/$CURRENT_USER/.m2/ /home/$CURRENT_USER/.cache/ 2>/dev/null || true
chown -R $CURRENT_USER:$CURRENT_GROUP "$PROJECT_DIR" 2>/dev/null || true
print_success "目录权限设置完成"

# 交互式 Git 配置设置
print_step "Git 用户配置"
print_info "请设置您的 Git 用户信息（这些信息将用于提交记录）"

# 检查是否已有配置
git_name=$(git config --global user.name 2>/dev/null)
git_email=$(git config --global user.email 2>/dev/null)

if [ -n "$git_name" ] && [ -n "$git_email" ]; then
    print_success "检测到现有 Git 配置"
    echo -e "${WHITE}└─   用户名: $git_name${NC}"
    echo -e "${WHITE}└─   邮箱: $git_email${NC}"
    echo
    echo -e "${YELLOW}是否要重新配置 Git 用户信息？ (y/N): ${NC}"
    read -r reconfigure
    if [[ ! "$reconfigure" =~ ^[Yy]$ ]]; then
        print_success "保持现有 Git 配置"
    else
        git_name=""
        git_email=""
    fi
fi

# 如果配置为空，则进行交互式设置
if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    echo
    print_info "开始交互式 Git 配置..."
    
    # 获取用户名
    while [ -z "$git_name" ]; do
        echo -e "${YELLOW}请输入您的 Git 用户名: ${NC}"
        read -r git_name
        if [ -z "$git_name" ]; then
            echo -e "${RED}用户名不能为空，请重新输入${NC}"
        fi
    done
    
    # 获取邮箱
    while [ -z "$git_email" ]; do
        echo -e "${YELLOW}请输入您的 Git 邮箱: ${NC}"
        read -r git_email
        if [ -z "$git_email" ]; then
            echo -e "${RED}邮箱不能为空，请重新输入${NC}"
        elif [[ ! "$git_email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
            echo -e "${RED}邮箱格式不正确，请重新输入${NC}"
            git_email=""
        fi
    done
    
    # 设置 Git 配置
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main || true
    
    print_success "Git 配置已设置完成"
    echo -e "${WHITE}└─   用户名: $git_name${NC}"
    echo -e "${WHITE}└─   邮箱: $git_email${NC}"
fi

# 检查 Java 版本
print_step "检查 Java 环境"
java -version 2>&1 | head -1 | sed 's/^/└─ /' | sed "s/^/$(echo -e ${GREEN})/" | sed "s/$/$(echo -e ${NC})/"

# Git 远程链接权限验证检测
print_step "Git 远程链接权限验证"
cd "$PROJECT_DIR" 2>/dev/null || {
    print_warning "无法进入项目目录，跳过 Git 远程权限检测"
    cd /workspaces
}

# 检查是否为 Git 仓库
if [ -d ".git" ]; then
    print_info "检测到 Git 仓库"
    
    # 获取远程仓库信息
    remote_url=$(git remote get-url origin 2>/dev/null)
    if [ -n "$remote_url" ]; then
        print_info "远程仓库: $remote_url"
        
        # 检测认证方式
        if echo "$remote_url" | grep -q "^git@"; then
            print_info "使用 SSH 认证方式"
            
            # 设置 SSH 代理
            print_info "设置 SSH 代理..."
            eval "$(ssh-agent -s)" >/dev/null 2>&1
            for key in ~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/id_ecdsa; do
                if [ -f "$key" ]; then
                    ssh-add "$key" >/dev/null 2>&1 && \
                    print_success "已添加 SSH 密钥: $key" || \
                    print_warning "无法添加 SSH 密钥: $key"
                fi
            done
            
            # 添加已知主机
            print_info "设置 SSH 已知主机..."
            mkdir -p ~/.ssh
            ssh_host=$(echo "$remote_url" | sed 's/.*@\([^:]*\).*/\1/')
            if ! grep -q "$ssh_host" ~/.ssh/known_hosts 2>/dev/null; then
                ssh-keyscan "$ssh_host" >> ~/.ssh/known_hosts 2>/dev/null && \
                print_success "已添加 $ssh_host 到已知主机" || \
                print_warning "无法添加 $ssh_host 到已知主机"
            fi
            
            # 测试连接 - 使用 git 命令而不是原始 SSH
            print_info "测试 SSH 连接..."
            if git ls-remote origin HEAD >/dev/null 2>&1; then
                print_success "SSH 连接测试成功"
            else
                print_warning "SSH 连接测试失败，请检查密钥配置"
                echo -e "${PURPLE}└─ 💡 提示：请确保 SSH 密钥已添加到远程仓库${NC}"
                echo -e "${YELLOW}└─ 调试信息：尝试手动运行以下命令测试连接：${NC}"
                echo -e "${WHITE}└─   ssh -T git@$ssh_host${NC}"
                echo -e "${WHITE}└─   git ls-remote origin HEAD${NC}"
            fi
        elif echo "$remote_url" | grep -q "^https://"; then
            print_info "使用 HTTPS 认证方式"
            
            # 检查 Git 凭据
            if git config --get credential.helper >/dev/null 2>&1; then
                print_success "检测到 Git 凭据助手"
            else
                print_warning "未配置 Git 凭据助手"
                echo -e "${PURPLE}└─ 💡 提示：请配置 Git 凭据助手或使用个人访问令牌${NC}"
            fi
            
            # 测试 HTTPS 连接
            print_info "测试 HTTPS 连接..."
            if git ls-remote origin HEAD >/dev/null 2>&1; then
                print_success "HTTPS 连接测试成功"
            else
                print_warning "HTTPS 连接测试失败，请检查认证信息"
                echo -e "${PURPLE}└─ 💡 提示：请检查用户名和密码/令牌配置${NC}"
            fi
        else
            print_warning "无法识别的远程 URL 格式"
        fi
        
        # 检查分支跟踪状态
        current_branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$current_branch" ]; then
            print_info "当前分支: $current_branch"
            
            # 检查上游分支
            upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
            if [ -n "$upstream" ]; then
                print_success "上游分支: $upstream"
                
                # 检查本地和远程分支的同步状态
                if git fetch --dry-run >/dev/null 2>&1; then
                    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
                    behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
                    
                    if [ "$ahead" -gt 0 ] || [ "$behind" -gt 0 ]; then
                        print_warning "分支同步状态: 领先 $ahead 提交, 落后 $behind 提交"
                        echo -e "${PURPLE}└─ 💡 提示：考虑执行 'git pull' 或 'git push' 来同步分支${NC}"
                    else
                        print_success "分支已与远程同步"
                    fi
                else
                    print_warning "无法获取远程分支信息"
                fi
            else
                print_warning "当前分支未设置上游分支"
                echo -e "${PURPLE}└─ 💡 提示：使用 'git push -u origin $current_branch' 设置上游分支${NC}"
            fi
        fi
    else
        print_warning "未配置远程仓库"
        echo -e "${PURPLE}└─ 💡 提示：使用 'git remote add origin <repository-url>' 添加远程仓库${NC}"
    fi
else
    print_warning "当前目录不是 Git 仓库"
    echo -e "${PURPLE}└─ 💡 提示：使用 'git init' 初始化 Git 仓库${NC}"
fi

# Flutter 项目初始化
print_step "Flutter 项目初始化"
print_info "运行 flutter pub get 获取依赖..."

# 确保正确的 JAVA_HOME 设置
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
print_info "JAVA_HOME 设置为: $JAVA_HOME"

# 检查是否在 Flutter 项目目录中
if [ -f "pubspec.yaml" ]; then
    print_info "在当前目录运行 flutter pub get..."
    flutter pub get
    print_success "当前目录 Flutter 依赖获取完成"
else
    # 为子目录中的每个 Flutter 项目运行 flutter pub get
    for dir in base essence purtato; do
        if [ -d "$dir" ] && [ -f "$dir/pubspec.yaml" ]; then
            print_info "在 $dir 目录运行 flutter pub get..."
            cd "$dir"
            flutter pub get
            cd ..
            print_success "$dir 目录 Flutter 依赖获取完成"
        fi
    done
fi

print_success "所有 Flutter 项目依赖获取完成"

# 完成提示
echo
echo -e "${GREEN}┌──────────────────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}│${WHITE}                    🎉 开发容器初始化完成！ 🎉                ${GREEN}│${NC}"
echo -e "${GREEN}│${WHITE}                                                              ${GREEN}│${NC}"
echo -e "${GREEN}│${WHITE}  🚀 现在可以开始开发了！                                     ${GREEN}│${NC}"
echo -e "${GREEN}└──────────────────────────────────────────────────────────────┘${NC}"

