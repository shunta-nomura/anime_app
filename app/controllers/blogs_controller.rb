class BlogsController < ApplicationController
  Query = AnimeApp::Client.parse <<-GRAPHQL
  query {
    viewer {
      username
      name
    }
  }
    GRAPHQL

  Anime = AnimeApp::Client.parse <<-GRAPHQL
  query {
    searchWorks(
      seasons: ["2017-spring"],
      orderBy: { field: WATCHERS_COUNT, direction: DESC },
      first: 3
    ) {
      edges {
        node {
          title
          watchersCount
        }
      }
    }
  }
  
    GRAPHQL
  def index
    @works = result.data.viewer.name
    binding.pry
  end

  private
  def result
    response = AnimeApp::Client.query(Query)
  end
  def animeresult
    response = AnimeApp::Client.query(Anime)
  end
end
