defmodule PiscineWeb.ErrorView do
  use PiscineWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("user_not_found.json", _assigns) do
    %{error: "User not found ! "}
  end

  def render("clock_not_found.json", _assigns) do
    %{error: "Clock not found ! "}
  end

  def render("workingtime_not_found.json", _assigns) do
    %{error: "Workingtime not found ! "}
  end

end
