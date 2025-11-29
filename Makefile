dev:
	@echo "Starting Phoenix server..."
	iex -S mix phx.server && echo "✔️ Phoenix server started"

setup:
	@echo "Starting Docker containers..."
	docker compose -f docker-compose-dev.yml up -d && echo "✔️ Docker containers started"
	@echo "Installing npm dependencies..."
	npm install --prefix assets && echo "✔️ npm dependencies installed"
	@echo "Running mix setup..."
	mix setup && echo "✔️ mix setup complete"
	@echo "Seeding database..."
	mix run priv/repo/seeds.exs && echo "✔️ Database seeded"

stop:
	@echo "Stopping Docker containers..."
	docker compose -f docker-compose-dev.yml down && echo "✔️ Docker containers stopped"
