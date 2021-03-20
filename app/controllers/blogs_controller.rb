class BlogsController < ApplicationController

  Anime = AnimeApp::Client.parse <<-GRAPHQL
  query {
    searchWorks(
      seasons: ["2017-spring"],
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

  def index
    @animes = animeresult.data.search_works.edges
  end

  def search
    # @aaaa = params[:keyword]
    @animes = searchresult(title: params[:keyword]).data.search_works.edges
    # binding.pry
  end

  private
  def animeresult
    response = AnimeApp::Client.query(Anime)
  end
  def searchresult(variables = {})
    response = AnimeApp::Client.query(Search, variables: variables)
  end
end
