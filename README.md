# Go с нуля - 11 Спринт - Итоговое задание

Начальный код для выполнения итогового задания 11 спринта курса "Разработчик Go с нуля".

Информация для тех, кто не может выполнить финальное задание 12-го спринта из-за ограничения доступа к Docker Hub. Выход есть! Можно вместо реестра образов Docker Hub использовать GitHub Container Registry, который точно доступен в РФ.

В GitHub-экшне нужно будет внести несколько правок, чтобы все заработало. В первую очередь заводим вспомогательные переменные окружения с реестром ghcr.io (GitHub Container Resitry) и названием образа:

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: my-app
```
Можно вместо конкретного названия образа использовать название репозитория:

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
```

Далее в jobs с деплоем образа в реестр на шаге логина пишем:

```yaml
- uses: docker/login-action@v4
  with:
    registry: ${{ env.REGISTRY }} # Реестр GitHub Container Registry
    username: ${{ github.actor }} # подставится ваш логин GitHub
    password: ${{ secrets.GITHUB_TOKEN }} # токен авторизации GitHub
```

В таком случае не нужно заводить какие-то свои секреты secrets с данными из Docker Hub. Будем использовать стандартный токен GitHub. Затем на шаге мета-данных пишем:

```yaml
- uses: docker/metadata-action@v6
  with:
    images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }} # имя образа вида ghcr.io/name
```

Готово! С такими настройками экшна ваш образ опубликуется не в Docker Hub, а в реестре GitHub Container Registry. От чего, в принципе, суть не меняется. Но на всякий случай напишите еще комментарий в самом начале для ревьюера:

```yaml
# Использую GitHub Container Registry, т.к. Docker Hub недоступен
```


