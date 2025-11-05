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

# --- ② debug_toolsをリポジトリから取得 ---
COPY repos/debug_tools.repos /tmp/debug_tools.repos
RUN mkdir -p /home/${user}/tools/src && \
    cd /home/${user}/tools && \
    vcs import src < /tmp/debug_tools.repos || true && \
    chown -R ${user}:${user} /home/${user}/tools

# --- ③ ユーザに戻す ---
USER ${user}

# --- ④ 起動時に環境を自動source ---
RUN echo '[ -f /home/${user}/autoware.proj/install/setup.bash ] && source /home/${user}/autoware.proj/install/setup.bash' >> /home/${user}/.bashrc
