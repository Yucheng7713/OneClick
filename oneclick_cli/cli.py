import click
import subprocess


@click.group()
def main():
	pass

@main.command()
def init():
	click.echo('Initializing env...')
	subprocess.call("./sh_scripts/setup.sh")

@main.command()
@click.argument('git_path')
def git_deploy(git_path):
	click.echo('Starting remote deployment...')
	subprocess.call(["./sh_scripts/remote_deploy.sh", git_path])

@main.command()
@click.argument('local_path')
def local_deploy(local_path):
	click.echo('Starting local deployment...')
	subprocess.call("./sh_scripts/local_deploy.sh %s", local_path)

@main.command()
def access():
	subprocess.call("./sh_scripts/access.sh")

@main.command()
def destroy():
	click.echo('Destroying K8S cluster...')
	subprocess.call("./sh_scripts/down.sh")