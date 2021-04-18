class BlogsController < ApplicationController

  Anime = AnimeApp::Client.parse <<-GRAPHQL
  query ($season:String! ) {
    searchWorks(
      seasons: [$season],
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
            annictId
            image {
              facebookOgImageUrl
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
              seasonName
              seasonYear
              twitterUsername
              episodesCount
              media
              staffs {
                edges {
                  node {
                    roleText
                    name
                  }
                }
              }
              casts {
                edges {
                  node {
                    character {
                      name
                    }
                    name
                  }
                }
              }
              image {
                facebookOgImageUrl
              }
            }
          }
        }
      }
        GRAPHQL
        Staff = AnimeApp::Client.parse <<-GRAPHQL
        query ($id: Int!) {
          searchWorks(
            annictIds: [$id],
            orderBy: { field: WATCHERS_COUNT, direction: DESC },
            first: 5
          ) {
            edges {
              node {
                staffs {
                  edges {
                    node {
                      name
                      roleOther
                    }
                  }
                }
              }
            }
          }
        }
          GRAPHQL

  def index
    now_season
    @animes = animeresult(season: @season_year).data.search_works.edges
  end

  def search
    @animes = searchresult(title: params[:keyword]).data.search_works.edges
  end

  def show
    @animes = work(id: params[:id].to_i).data.search_works.edges
    @staffs = staff(id: params[:id].to_i).data.search_works.edges
  end

  private
  def animeresult(variables = {})
    response = AnimeApp::Client.query(Anime, variables: variables)
  end
  def searchresult(variables = {})
    response = AnimeApp::Client.query(Search, variables: variables)
  end
  def work(variables = {})
    response = AnimeApp::Client.query(Title, variables: variables)
  end
  def staff(variables = {})
    response = AnimeApp::Client.query(Staff, variables: variables)
  end
  def now_season
    require "date"
    day = Date.today
    year = day.year
    month = day.month
    season =""
    if 10 <= month 
      season = "winter"
    elsif 7 <= month 
      season = "summer"
    elsif 4 <= month 
      season = "spring"
    else
      season = "winter"
    end
    @season_year = year.to_s + "-" + season
  end
end
