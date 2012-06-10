# encoding: utf-8
class MembersController < ApplicationController
  before_filter :login_required
  respond_to :html, :json

  def index
    @members = Member.order(:name)
    @members = @members.in_scope(params[:scope]) if params[:scope]
    respond_with @members
  end


  def new
    @member = Member.new
  end


  def edit
    @member = Member.find(params[:id])
  end


  def create
    @member = Member.new(params[:member])

    if @member.save
      redirect_to members_url, notice: "Člen #{@member.name} přidán."
    else
      render action: "new"
    end
  end


  def update
    @member = Member.find(params[:id])

    if @member.update_attributes(params[:member])
      redirect_to members_url, notice: "Člen #{@member.name} upraven."
    else
      render action: "edit"
    end
  end


  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    redirect_to members_url, notice: "Člen #{@member.name} smazán."
  end
end
