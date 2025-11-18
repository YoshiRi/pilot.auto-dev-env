# ベースイメージ指定
ARG base
FROM ${base}

# 変数
ARG user
ARG DEBIAN_FRONTEND=noninteractive

USER root

# --- ① nvidia関連をpurge ---
RUN apt-get update && \
    apt-get remove -y --purge '^nvidia-.*' && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# github.com のホスト鍵を登録
RUN mkdir -p /root/.ssh && \
ssh-keyscan github.com >> /root/.ssh/known_hosts

# --- ② debug_toolsをリポジトリから取得 ---
COPY repos/debug_tools.repos /tmp/debug_tools.repos
RUN --mount=type=ssh  \
    mkdir -p /home/${user}/autoware.proj/tools && \
    cd /home/${user}/autoware.proj && \
    vcs import tools < /tmp/debug_tools.repos && \
    chown -R ${user}:${user} /home/${user}/autoware.proj/tools

# --- ③ ユーザに戻す ---
USER ${user}

# --- ③ ccache用ディレクトリ作成 --- (build時キャッシュ用)
ENV CCACHE_DIR=/home/${user}/.ccache
RUN mkdir -p /home/${user}/.ccache && \
    chown -R ${user}:${user} /home/${user}/.ccache

# --- ④ 起動時に環境を自動source ---
RUN echo '[ -f /home/${user}/autoware.proj/install/setup.bash ] && source /home/${user}/autoware.proj/install/setup.bash' >> /home/${user}/.bashrc
