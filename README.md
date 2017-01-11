# Docker Study for Server

## 설치
`docker_install.sh` 참조.

CentOS7 에서 실행시 설치되도록 하는 Script

## 기본 용어

1. Image
   - **Filesystem** 과 **여러 변수들**로 이루어진 파일.
   - Docker 에 의해 **변하지 않는다**.
   - Build 된 방법에 따라서 명령 하나만 실행하고 종료할 수도 있고, DB 를 실행시키거나 OS 를 구동하는 등 복잡한 작업 또한 할 수 있다.
   - **모든 Docker 사용자들이 Build 해서 사용할 수 있다.**
2. Container
   - **Image 가 실행**되는 객체.

## 기본 Command Line Interface (CLI)

1. `docker run <image name>`
   - Container 를 새로 생성하고, `<image name>` 에 해당하는 **Image 를 생성한 Container 에 불러온다**.
   - 실행 순서
     1. `<image name>` 에 해당하는 Image 를 가지고 있는지 확인한다.
     1. 가지고 있지 않거나 최신 Image 가 아니라면, Docker Hub 로부터 Download 한다.
     1. Image 를 Container 에 불러오고, Container 를 실행시킨다.
1. `docker ps`
   - Docker **Container 들을 나열**하는 명령어.
   - `-a` 옵션을 붙일 경우 종료된 Container 또한 나열해준다.
     - 언제까지 나열해주나???
1. `docker images`
   - Local system 에 있는 Image 들을 볼 수 있는 명령어.
   - Image 들의 용량을 확인할 수 있다.
1. `docker start`
   - 이미 있는 Container 를 시작시키는 명령어
1. `docker attach`
   - 실행 중인 Container 를 TTY 에 붙이는 명령어
1. `docker stop`
   - 실행 중인 Container 를 중지시키는 명령어
1. `docker logs`
   - Container 의 출력 (stdout) 을 볼 수 있는 명령어
1. `docker version`
   - Docker 의 Version 정보를 볼 수 있는 명령어

## Docker Image 찾기

1. Docker Hub 에서 검색을 한다.
   - 다음과 같은 검색창을 볼 수 있다.
   - ![DockerHubSearch][DockerHubSearch]
1. 검색 결과에서 원하는 Image 로 들어간다.
1. 해당 Image 의 실행 방법을 보고 실행한다.

[DockerHubSearch]:https://docs.docker.com/engine/getstarted/tutimg/browse_and_search.png

## Docker Image 만들기

### 사용할 수 있는 명령문들

1. `FROM` 문
   - 기반이 될 Image 를 명시한다.
   - `FROM docker/whalesay:latest` 와 같이 사용 가능하다.
1. `RUN` 문
   - 실행할 명령어들을 작성한다.
   - Package 설치 등이 가능하다.
   - `RUN apt-get -y update && apt-get install -y fortunes` 와 같이 사용 가능하다.
1. `CMD` 문
   - 최종적으로 실행할 명령어를 작성한다.
   - `CMD /usr/games/fortune -a | cowsay` 와 같이 사용 가능하다.
1. 그 외의 명령어
   - [Docker Engine Reference][DockerEngineReference] 를 참조한다.

[DockerEngineReference]: https://docs.docker.com/engine/reference/builder

### Build 시의 메시지들

1. 매 명령문마다 하나의 Step 이 진행된다.
1. 하나의 Step 이 끝날 때마다 Unique 한 ID 가 생성된다.
