# OfficeMail Official Marketplace 0.3

> **Pre-release (RC) channel** — 이 브랜치는 정식 릴리즈 전 테스트용입니다.
>
> - 현재 RC 태그: `0.2.99-rc.f21ba85`
> - RC 설치:
>   - `/plugin marketplace add jiransoft/om-official@rc`
>   - `/plugin install officemail@officemail-rc`
> - 안정 버전으로 복귀:
>   - `/plugin uninstall officemail@officemail-rc`
>   - `/plugin marketplace remove officemail-rc`
> - RC 빌드의 플러그인 파일(스킬/MCP manifest)과 바이너리는 같은 빌드로부터
>   동기화되지만, 안정 버전 대비 검증이 덜 되었을 수 있습니다.

OfficeMail 서비스의 공식 마켓플레이스입니다.
메일, 캘린더 등 OfficeMail이 제공하는 서비스를 AI 에이전트에서 사용할 수 있습니다.

## OfficeMail CLI 0.2.99-rc.f21ba85

AI 에이전트가 OfficeMail 서비스의 이메일과 캘린더를 읽고, 보내고, 관리할 수 있는
Claude Code 플러그인이자 MCP 서버입니다.
OfficeMail(Cyrus IMAP + Postfix 기반) 전용이며,
다른 이메일 서비스나 JMAP 서버에서는 동작하지 않습니다.

### 설치

#### Claude Code

두 단계로 설치합니다: 마켓플레이스 등록 → 플러그인 설치.

##### 1단계 — 마켓플레이스 추가

세션 내부:

```text
/plugin marketplace add jiransoft/om-official
```

또는 CLI:

```bash
claude plugin marketplace add jiransoft/om-official
```

##### 2단계 — 플러그인 설치

세션 내부:

```text
/plugin install officemail@officemail
```

또는 CLI:

```bash
claude plugin install officemail@officemail
```

설치 후 세션을 재시작해야 플러그인이 로드됩니다.

##### 3단계 — 인증 설정

새 세션에서 설정 스킬을 실행하세요:

```text
/officemail:omail-setup
```

#### Claude Desktop

Claude Desktop에서 MCP 서버로 사용할 수 있습니다.

1. [릴리즈 페이지](https://github.com/jiransoft/om-official/releases)에서
   플랫폼에 맞는 `.mcpb` 파일을 다운로드합니다 (`officemail-{platform}.mcpb`)
2. 더블클릭하면 바이너리와 MCP 서버 설정이 자동으로 설치됩니다
3. 터미널에서 인증을 설정합니다:

   ```bash
   omail auth setup --email you@company.com
   ```

4. Claude Desktop을 재시작하면 도구(tools)를 사용할 수 있습니다

### 업데이트

#### Claude Code

##### 세션 내부 (대화형 UI)

```text
/plugin
```

1. **Marketplaces** 탭 → officemail 마켓플레이스를 갱신합니다
2. **Installed** 탭 → officemail 플러그인을 선택하여 업데이트합니다

##### CLI (터미널에서 직접 실행)

```bash
claude plugin marketplace update officemail
claude plugin update officemail@officemail
```

업데이트 후 세션을 재시작하면 적용됩니다.
실행파일(`omail`)도 새 세션 시작 시 훅이 자동으로 업데이트합니다.

##### 자동 업데이트 설정

Marketplaces 탭에서 officemail의 auto-update를 활성화하면,
Claude Code 시작 시 마켓플레이스 갱신과 플러그인 업데이트가 자동으로 수행됩니다.
써드파티 마켓플레이스는 기본 비활성화이므로 직접 켜야 합니다.
실행파일(`omail`) 업데이트를 위해 세션 재시작이 필요합니다.

#### Claude Desktop

[릴리즈 페이지](https://github.com/jiransoft/om-official/releases)에서
최신 `.mcpb` 파일을 다운로드하여 더블클릭하면 덮어쓰기 설치됩니다.

### 제거

#### Claude Code

세션 내부:

```text
/plugin uninstall officemail
```

또는 CLI:

```bash
claude plugin uninstall officemail
```

마켓플레이스도 제거하려면:

```bash
claude plugin marketplace remove jiransoft/om-official
```

#### Claude Desktop

1. MCP 설정 파일에서 `officemail` 항목을 삭제합니다:
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
2. Claude Desktop을 재시작합니다

#### 인증 및 데이터 제거

`~/.config/officemail/`의 설정 파일과 시스템 키체인의 인증 토큰은
CLI, Claude Code 플러그인, Claude Desktop MCP 서버가 공유합니다.
**모든 클라이언트를 제거한 후에만** 삭제하세요:

```bash
# 설정 파일
rm -rf ~/.config/officemail

# 키체인 항목 — macOS (항목이 없을 때까지 반복)
security delete-generic-password -s officemail-cli

# 키체인 항목 — Linux
secret-tool clear service officemail-cli

# 로그 — macOS
rm -rf ~/Library/Logs/officemail

# 로그 — Linux
rm -rf ~/.local/state/officemail
```

Windows (PowerShell):

```powershell
# 설정 및 암호화된 토큰
Remove-Item "$env:LOCALAPPDATA\officemail" -Recurse -Force
```

#### 삭제 확인

```bash
which omail                  # 출력 없으면 정상
ls ~/.config/officemail      # "No such file or directory"이면 정상
```

### 인증

인증 토큰은 플랫폼 보안 저장소(macOS Keychain, Linux Secret Service,
Windows DPAPI)에 저장됩니다. 설정 파일(`~/.config/officemail/config.json`)에는
토큰이 포함되지 않습니다.
Claude Code 플러그인, Claude Desktop MCP 서버, CLI 모두 같은 인증 정보를
공유하므로 한 곳에서 인증하면 어디서든 사용할 수 있습니다.

```bash
omail auth setup --email you@company.com   # OAuth 로그인 (브라우저 열림)
omail auth setup                           # 또는 수동 설정 (JMAP URL + 토큰)
omail doctor                               # 연결 확인
```

### 멀티 프로필

여러 OfficeMail 계정을 프로필로 관리할 수 있습니다.
기존 단일 계정 설정은 첫 실행 시 자동으로 마이그레이션됩니다.

```bash
# 프로필 추가
omail --profile work auth setup --email you@work.com
omail --profile personal auth setup --email you@personal.com

# 프로필 목록 / 전환 / 삭제 / 이름 변경
omail auth list                    # 모든 프로필 조회
omail auth switch work             # 기본 프로필 변경
omail auth remove old-profile      # 프로필 삭제
omail auth rename old-name new-name  # 프로필 이름 변경
omail auth status                  # 전체 프로필 연결 상태 확인

# 프로필 별칭 관리
omail auth alias add work w        # 별칭 추가
omail auth alias remove work w     # 별칭 삭제
omail auth alias list              # 모든 별칭 조회
omail auth alias list work         # 특정 프로필 별칭 조회

# 디버그 로그 전송
omail auth report support@company.com          # 현재 프로필 기준
omail --profile work auth report admin@co.com  # 특정 프로필 기준

# 특정 프로필로 명령 실행
omail --profile work mail +triage
omail --profile personal calendar +agenda
```

MCP 도구에서는 `profile` 파라미터로 프로필을 지정하거나,
`account_switch` 도구로 세션 내 기본 프로필을 변경할 수 있습니다.

### 주요 기능

- **메일** — 읽기, 보내기, 답장, 전달, 리다이렉트, 검색, 분류, 플래그, 초안, 실시간 감시
- **캘린더** — 일정 CRUD, 반복 일정, 알림, 온라인 회의, 종일 일정,
  참석자 관리, RSVP, 캘린더 CRUD, 공유, 크로스 계정 복사, iCalendar 파싱
- **연락처** — 연락처 CRUD, 검색, 주소록 조회

### 스킬

| 스킬             | 설명                                                                |
| ---------------- | ------------------------------------------------------------------- |
| `omail`          | 개요, 글로벌 플래그, 종료 코드, 보안 규칙, 스키마                   |
| `omail-setup`    | 인증 (OAuth/수동), 연결 진단 (doctor)                               |
| `omail-mail`     | 메일 전체: 보내기, 답장, 분류, 읽기, 검색, 이동, 플래그, 초안, 감시 |
| `omail-calendar` | 캘린더 전체: 일정 CRUD, 반복, 알림, RSVP, 공유, 파싱                |
| `omail-contacts` | 연락처 전체: 연락처 CRUD, 검색, 주소록 조회                         |

### 프롬프트 예시

Claude Code에서 자연어로 사용할 수 있습니다:

#### 메일

- "안 읽은 메일 요약해줘"
- "오늘 온 메일 중 중요한 것만 알려줘"
- "`someone@example.com`에게 회의 일정 확인 메일 보내줘"
- "이 메일에 답장해줘: 참석하겠습니다"
- "지난주 예산 관련 메일 찾아줘"
- "새 메일이 오면 텔레그램으로 알려줘" (`+watch` 사용)

#### 캘린더

- "이번 주 일정 알려줘"
- "내일 오후 2시에 팀 회의 잡아줘"
- "다음 주 월요일 비어있는 시간 알려줘"
- "반복 회의를 매주 금요일로 변경해줘"
- "다음 회의 초대에 수락으로 응답해줘"

#### 멀티 계정

- "회사 계정으로 로그인해줘"
- "개인 메일함 확인해줘" (프로필 지정)
- "회사 계정에서 보낸 메일 중 어제 것만 보여줘"
- "모든 계정 연결 상태 확인해줘" (`auth status`)

#### 연락처

- "연락처에서 김동수 찾아줘"
- "Alice Kim을 연락처에 추가해줘 (alice@example.com)"
- "이 사람 연락처 상세 정보 보여줘"
- "주소록 목록 보여줘"

#### 설정

- "OfficeMail 로그인해줘"
- "연결 상태 확인해줘" (`doctor`)

### 구성

- **Skills** — 5개 도메인별 AI 에이전트 지시 파일
- **Hooks** — 첫 세션 시작 시 `omail` 실행파일 자동 설치
- **실행파일** — macOS, Linux, Windows (arm64, x64) 6개 플랫폼 빌드 제공

실행파일은 [릴리즈 페이지](https://github.com/jiransoft/om-official/releases)에서
다운로드할 수 있으며, 플러그인 설치 시 자동으로 다운로드됩니다.

### 수동 설치

```bash
curl -L -o omail https://github.com/jiransoft/om-official/releases/latest/download/omail-darwin-arm64
chmod +x omail
sudo mv omail /usr/local/bin/
```
