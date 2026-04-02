# 시스템 셋업 스크립트

Ubuntu/Debian 시스템에서 Java, Docker, Docker Compose를 자동으로 설치하는 유연한 bash 스크립트입니다.

[English Documentation](README.md)

## 주요 기능

- **Java 설치**: 원하는 OpenJDK 버전 설치 가능 (8, 17, 21, 25, 등)
- **Docker 설치**: Docker CE 및 사용자 권한 자동 설정
- **Docker Compose**: Docker Compose 플러그인 설치
- **유연한 옵션**: 간단한 플래그로 원하는 구성요소만 선택 가능
- **순서 무관**: 옵션 순서에 상관없이 사용 가능

## 사용 전

Debian/Ubuntu 시스템에서, 리포지토리를 클론하거나 스크립트를 실행하기 전에 git이 설치되어 있는지 확인하세요.

```bash
sudo apt update && sudo apt install -y git
```

리포지토리를 클론합니다 (실제 리포지토리 URL과 디렉토리 이름으로 교체하세요):

```bash
git clone https://github.com/HyunwooKiim/setup.sh
cd setup.sh
```

## 빠른 시작

```bash
# 실행 권한 부여
chmod +x setup.sh

# 기본 설정으로 실행 (Java 21 + Docker + Docker Compose)
./setup.sh

# 가이드 보기
./setup.sh guide
```

## 사용법

```bash
./setup.sh [옵션...]
```

### 옵션

| 옵션 | 설명 |
|------|------|
| `guide` | 상세 사용 가이드 표시 |
| `delete` | 스크립트 및 관련 파일 정리 |
| `[숫자]` | 특정 Java 버전 설치 (예: 21, 17, 11, 8) |
| `javaless` | Java 설치 건너뛰기 |
| `dockerless` | Docker 설치 건너뛰기 (자동으로 composeless 적용) |
| `composeless` | Docker Compose 설치 건너뛰기 |
| `updateless` | 시스템 업데이트 건너뛰기 |
| `default` | 기본 설정 사용 |

### 사용 예제

```bash
# 기본 설정으로 모두 설치 (Java 21 + Docker + Docker Compose)
./setup.sh

# Java 17 + Docker + Docker Compose 설치
./setup.sh 17

# Java 없이 Docker만 설치
./setup.sh javaless

# Docker 없이 Java 21만 설치
./setup.sh dockerless

# Java와 Docker 설치, Compose 제외
./setup.sh composeless

# Java 11과 Docker 설치, Compose 제외
./setup.sh 11 composeless

# 시스템 업데이트 없이 Java만 설치
./setup.sh updateless dockerless

# 여러 옵션 조합 (순서 무관)
./setup.sh javaless dockerless updateless

# 설치 후 스크립트 파일 정리
./setup.sh delete
```

## Delete 기능

`delete` 옵션은 설치 완료 후 스크립트와 관련 파일을 정리합니다:

- **디렉토리 이름이 `setup.sh`인 경우**: 
  - 상위 디렉토리로 이동 후 `setup.sh` 디렉토리 전체 삭제
  
- **디렉토리 이름이 다른 경우**: 
  - 다음 파일만 삭제: `.git`, `README.md`, `koREADME.md`, `setup.sh`

```bash
# 설치 완료 후 정리
./setup.sh delete
```

## 중요 사항

- **옵션 순서**: 옵션은 어떤 순서로든 지정 가능
  - `./setup.sh dockerless javaless` = `./setup.sh javaless dockerless`

- **자동 의존성**: 
  - `dockerless` 사용 시 자동으로 `composeless` 적용 (Docker Compose는 Docker 필요)

- **시스템 업데이트**: 
  - 기본적으로 시스템 업데이트 실행 (`apt-get update && apt-get upgrade`)
  - `updateless` 옵션으로 건너뛸 수 있음

- **Java 버전**: 
  - Java 버전은 숫자만 입력 가능
  - 기본값은 Java 21 (OpenJDK)
  - 주요 버전: 21, 17, 11, 8

- **Docker 권한**: 
  - 스크립트가 자동으로 `ubuntu` 사용자를 `docker` 그룹에 추가
  - 그룹 변경 사항 적용을 위해 재로그인이 필요할 수 있음

## 요구사항

- Ubuntu/Debian 기반 Linux 배포판
- `sudo` 권한
- 인터넷 연결

## 설치되는 항목

### 기본 설정 (`./setup.sh`)

1. **시스템 업데이트**
   - `apt-get update -y`
   - `apt-get upgrade -y`

2. **Java (OpenJDK 21)**
   - `openjdk-21-jdk`

3. **Docker**
   - Docker CE
   - Docker CLI
   - containerd.io
   - 사용자를 docker 그룹에 추가

4. **Docker Compose**
   - docker-compose-plugin

## 라이선스

이 스크립트는 유틸리티 도구입니다. 사용에 따른 책임은 사용자에게 있습니다.

## 기여

이슈나 Pull Request는 언제든 환영합니다.
