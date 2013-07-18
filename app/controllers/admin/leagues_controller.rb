class Admin::LeaguesController < ApplicationController
  before_filter :authenticate

  # GET /admin/leagues
  # GET /admin/leagues.json
  def index
    @leagues = League.reorder("id ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leagues }
    end
  end

  # GET /admin/leagues/new
  # GET /admin/leagues/new.json
  def new
    @league = League.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @league }
    end
  end

  # GET /admin/leagues/1/edit
  def edit
    @league = League.find(params[:id])
  end

  # POST /admin/leagues
  # POST /admin/leagues.json
  def create
    @league = League.new(params[:admin_league])

    respond_to do |format|
      if @league.save
        format.html { redirect_to @league, notice: 'League was successfully created.' }
        format.json { render json: @league, status: :created, location: @league }
      else
        format.html { render action: "new" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/leagues/1
  # PUT /admin/leagues/1.json
  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.html { redirect_to admin_leagues_path, notice: 'League was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/leagues/1
  # DELETE /admin/leagues/1.json
  def destroy
    @league = League.find(params[:id])
    @league.destroy

    respond_to do |format|
      format.html { redirect_to admin_leagues_url }
      format.json { head :no_content }
    end
  end
end
