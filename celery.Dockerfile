FROM sitespeedio/webbrowsers:chrome-119.0-firefox-119.0-edge-119.0

ARG firefox_ver=119.0.
ARG geckodriver_ver=0.33.0
ARG build_rev=0

# As this image cannot run in non-headless mode anyway, it's better to forcibly
# enable it, regardless whether WebDriver client requests it in capabilities or
# not.
ENV MOZ_HEADLESS=1
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update \
    # dependencies for building Python packages
    && apt-get install -y build-essential \
    # psycopg2 dependencies
    && apt-get install -y libpq-dev \
    # Additional dependencies
    && apt-get install -y telnet netcat-openbsd \
    # youtube processor dependency
    && apt-get install -y ffmpeg \
    # cleaning up unused files
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

# install deps
RUN set -ex;

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    gnupg \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libcairo2 \
    libatspi2.0-0 \
    sshpass \
    lftp \
    openssh-server \
    rsync \
    --no-install-recommends

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    git \
    python3.12-gdbm \
    supervisor


# As this image cannot run in non-headless mode anyway, it's better to forcibly
# enable it, regardless whether WebDriver client requests it in capabilities or
# not.
ENV MOZ_HEADLESS=1

# set display port to avoid crash
ENV DISPLAY=:99

ENV PATH $PATH:/usr/local/bin

ENV PYENV_ROOT /usr/local/bin/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
RUN pyenv install 3.12.7 && pyenv global 3.12.7
RUN echo "$(pyenv init -)" > ~/.bashrc

RUN wget https://github.com/mozilla/geckodriver/releases/download/v${geckodriver_ver}/geckodriver-v${geckodriver_ver}-linux64.tar.gz
RUN tar -xvzf geckodriver-v${geckodriver_ver}-linux64.tar.gz
RUN mv geckodriver /usr/local/bin/

RUN pip3 install poetry

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

ENV TZ Etc/UTC
