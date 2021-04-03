class BlogsController < ApplicationController

  Anime = AnimeApp::Client.parse <<-GRAPHQL
  query {
    searchWorks(
      seasons: ["2021-winter"],
      orderBy: { field: WATCHERS_COUNT, direction: DESC },
      first: 5
    ) {
      edges {
        node {
          title
          watchersCount
          id
          annictId
          image {
            facebookOgImageUrl
          }
        }
      }
    }
  }
    GRAPHQL

    Search = AnimeApp::Client.parse <<-GRAPHQL
    query ($title: String!) {
      searchWorks(
        titles: [$title],
        orderBy: { field: WATCHERS_COUNT, direction: DESC },
        first: 5
      ) {
        edges {
          node {
            title
            watchersCount
            image {
              recommendedImageUrl
            }
          }
        }
      }
    }
      GRAPHQL

      Title = AnimeApp::Client.parse <<-GRAPHQL
      query ($id: Int!) {
        searchWorks(
          annictIds: [$id],
          orderBy: { field: WATCHERS_COUNT, direction: DESC },
          first: 5
        ) {
          edges {
            node {
              title
              watchersCount
              image {
                facebookOgImageUrl
              }
            }
          }
        }
      }
        GRAPHQL

  def index
    @animes = animeresult.data.search_works.edges
  end

  def search
    @animes = searchresult(title: params[:keyword]).data.search_works.edges
  end

  def show
    @animes = work(id: params[:id].to_i).data.search_works.edges
  end

  private
  def animeresult
    response = AnimeApp::Client.query(Anime)
  end
  def searchresult(variables = {})
    response = AnimeApp::Client.query(Search, variables: variables)
  end
  def work(variables = {})
    response = AnimeApp::Client.query(Title, variables: variables)
  end
end
