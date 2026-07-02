import { dag, Container, Directory, object, func } from "@dagger.io/dagger"

@object()
class Ci {
  @func()
  async test(source: Directory): Promise<string> {
    return dag
      .container()
      .from("node:22")
      .withDirectory("/src", source)
      .withWorkdir("/src")
      .withExec(["corepack", "enable"])
      .withExec(["pnpm", "install"])
      .withExec(["pnpm", "test"])
      .stdout()
  }

  @func()
  async lint(source: Directory): Promise<string> {
    return dag
      .container()
      .from("ghcr.io/oxsecurity/megalinter:v9")
      .withDirectory("/tmp/lint", source)
      .withExec(["/entrypoint.sh"])
      .stdout()
  }

  @func()
  async ci(source: Directory): Promise<string> {
    const [lintResult, testResult] = await Promise.all([
      this.lint(source),
      this.test(source),
    ])
    return `Lint: OK\nTest: OK\n${lintResult}\n${testResult}`
  }
}
