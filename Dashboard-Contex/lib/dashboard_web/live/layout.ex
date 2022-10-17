defmodule DashboardWeb.Layout do
  use Phoenix.LiveView

  alias DashboardWeb.PageLive

  def render(assigns) do
    ~H"""
      <div class="dashboard">
      <aside class="search-wrap">


        <div class="user-actions">
          <button>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M13.094 2.085l-1.013-.082a1.082 1.082 0 0 0-.161 0l-1.063.087C6.948 2.652 4 6.053 4 10v3.838l-.948 2.846A1 1 0 0 0 4 18h4.5c0 1.93 1.57 3.5 3.5 3.5s3.5-1.57 3.5-3.5H20a1 1 0 0 0 .889-1.495L20 13.838V10c0-3.94-2.942-7.34-6.906-7.915zM12 19.5c-.841 0-1.5-.659-1.5-1.5h3c0 .841-.659 1.5-1.5 1.5zM5.388 16l.561-1.684A1.03 1.03 0 0 0 6 14v-4c0-2.959 2.211-5.509 5.08-5.923l.921-.074.868.068C15.794 4.497 18 7.046 18 10v4c0 .107.018.214.052.316l.56 1.684H5.388z"/></svg>
          </button>
          <button>
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M12 21c4.411 0 8-3.589 8-8 0-3.35-2.072-6.221-5-7.411v2.223A6 6 0 0 1 18 13c0 3.309-2.691 6-6 6s-6-2.691-6-6a5.999 5.999 0 0 1 3-5.188V5.589C6.072 6.779 4 9.65 4 13c0 4.411 3.589 8 8 8z"/><path d="M11 2h2v10h-2z"/></svg>
          </button>
        </div>
      </aside>

      <header class="menu-wrap">
        <figure class="user">
          <div class="user-avatar">
            <img src="/images/strong_compute_icon.png" alt="Strong Compute Logo"/>
            </div>
          <figcaption>
            Strong Compute Data Center
          </figcaption>
        </figure>

        <nav>
          <a href="#" phx-click="render_home_9">
          HOME PAGE
          </a>

          <section class="dicover">
            <h3>SC 9</h3>

            <ul>
              <li>
                <a href="#" phx-click="render_cpu_9">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cpu" viewBox="0 0 16 16">
                <path d="M5 0a.5.5 0 0 1 .5.5V2h1V.5a.5.5 0 0 1 1 0V2h1V.5a.5.5 0 0 1 1 0V2h1V.5a.5.5 0 0 1 1 0V2A2.5 2.5 0 0 1 14 4.5h1.5a.5.5 0 0 1 0 1H14v1h1.5a.5.5 0 0 1 0 1H14v1h1.5a.5.5 0 0 1 0 1H14v1h1.5a.5.5 0 0 1 0 1H14a2.5 2.5 0 0 1-2.5 2.5v1.5a.5.5 0 0 1-1 0V14h-1v1.5a.5.5 0 0 1-1 0V14h-1v1.5a.5.5 0 0 1-1 0V14h-1v1.5a.5.5 0 0 1-1 0V14A2.5 2.5 0 0 1 2 11.5H.5a.5.5 0 0 1 0-1H2v-1H.5a.5.5 0 0 1 0-1H2v-1H.5a.5.5 0 0 1 0-1H2v-1H.5a.5.5 0 0 1 0-1H2A2.5 2.5 0 0 1 4.5 2V.5A.5.5 0 0 1 5 0zm-.5 3A1.5 1.5 0 0 0 3 4.5v7A1.5 1.5 0 0 0 4.5 13h7a1.5 1.5 0 0 0 1.5-1.5v-7A1.5 1.5 0 0 0 11.5 3h-7zM5 6.5A1.5 1.5 0 0 1 6.5 5h3A1.5 1.5 0 0 1 11 6.5v3A1.5 1.5 0 0 1 9.5 11h-3A1.5 1.5 0 0 1 5 9.5v-3zM6.5 6a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3z"/>
              </svg>
                  CPU
                </a>
              </li>

              <li>
                <a href="#" phx-click="render_gpu_9">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gpu-card" viewBox="0 0 16 16">
                <path d="M4 8a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0Zm7.5-1.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"/>
                <path d="M0 1.5A.5.5 0 0 1 .5 1h1a.5.5 0 0 1 .5.5V4h13.5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-.5.5H2v2.5a.5.5 0 0 1-1 0V2H.5a.5.5 0 0 1-.5-.5Zm5.5 4a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5ZM9 8a2.5 2.5 0 1 0 5 0 2.5 2.5 0 0 0-5 0Z"/>
                <path d="M3 12.5h3.5v1a.5.5 0 0 1-.5.5H3.5a.5.5 0 0 1-.5-.5v-1Zm4 1v-1h4v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5Z"/>
              </svg>
                  GPU
                </a>
              </li>

              <li>
                <a href="#">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-square" viewBox="0 0 16 16">
                <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
              </svg>
                  BMC
                </a>
              </li>

            </ul>
          </section>

          <section class="dicover">
            <h3>SC 10</h3>

            <ul>
              <li>
                <a href="#" phx-click="render_cpu_10">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cpu" viewBox="0 0 16 16">
                <path d="M5 0a.5.5 0 0 1 .5.5V2h1V.5a.5.5 0 0 1 1 0V2h1V.5a.5.5 0 0 1 1 0V2h1V.5a.5.5 0 0 1 1 0V2A2.5 2.5 0 0 1 14 4.5h1.5a.5.5 0 0 1 0 1H14v1h1.5a.5.5 0 0 1 0 1H14v1h1.5a.5.5 0 0 1 0 1H14v1h1.5a.5.5 0 0 1 0 1H14a2.5 2.5 0 0 1-2.5 2.5v1.5a.5.5 0 0 1-1 0V14h-1v1.5a.5.5 0 0 1-1 0V14h-1v1.5a.5.5 0 0 1-1 0V14h-1v1.5a.5.5 0 0 1-1 0V14A2.5 2.5 0 0 1 2 11.5H.5a.5.5 0 0 1 0-1H2v-1H.5a.5.5 0 0 1 0-1H2v-1H.5a.5.5 0 0 1 0-1H2v-1H.5a.5.5 0 0 1 0-1H2A2.5 2.5 0 0 1 4.5 2V.5A.5.5 0 0 1 5 0zm-.5 3A1.5 1.5 0 0 0 3 4.5v7A1.5 1.5 0 0 0 4.5 13h7a1.5 1.5 0 0 0 1.5-1.5v-7A1.5 1.5 0 0 0 11.5 3h-7zM5 6.5A1.5 1.5 0 0 1 6.5 5h3A1.5 1.5 0 0 1 11 6.5v3A1.5 1.5 0 0 1 9.5 11h-3A1.5 1.5 0 0 1 5 9.5v-3zM6.5 6a.5.5 0 0 0-.5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 0-.5-.5h-3z"/>
              </svg>
                  CPU
                </a>
              </li>

              <li>
                <a href="#" phx-click="render_gpu_10">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gpu-card" viewBox="0 0 16 16">
                <path d="M4 8a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0Zm7.5-1.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"/>
                <path d="M0 1.5A.5.5 0 0 1 .5 1h1a.5.5 0 0 1 .5.5V4h13.5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-.5.5H2v2.5a.5.5 0 0 1-1 0V2H.5a.5.5 0 0 1-.5-.5Zm5.5 4a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5ZM9 8a2.5 2.5 0 1 0 5 0 2.5 2.5 0 0 0-5 0Z"/>
                <path d="M3 12.5h3.5v1a.5.5 0 0 1-.5.5H3.5a.5.5 0 0 1-.5-.5v-1Zm4 1v-1h4v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5Z"/>
              </svg>
                  GPU
                </a>
              </li>

              <li>
                <a href="#">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-square" viewBox="0 0 16 16">
                <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
              </svg>
                  BMC
                </a>
              </li>

            </ul>
          </section>

          <section class="tools">
            <h3>Tools</h3>

            <ul>
              <li>
              <a href="#">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope" viewBox="0 0 16 16">
              <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4Zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2Zm13 2.383-4.708 2.825L15 11.105V5.383Zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741ZM1 11.105l4.708-2.897L1 5.383v5.722Z"/>
            </svg>
                Log Info
              </a>
              </li>
              <li>
                <a href="#">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M17.498,11.697c-0.453-0.453-0.704-1.055-0.704-1.697c0-0.642,0.251-1.244,0.704-1.697c0.069-0.071,0.15-0.141,0.257-0.22c0.127-0.097,0.181-0.262,0.137-0.417c-0.164-0.558-0.388-1.093-0.662-1.597c-0.075-0.141-0.231-0.22-0.391-0.199c-0.13,0.02-0.238,0.027-0.336,0.027c-1.325,0-2.401-1.076-2.401-2.4c0-0.099,0.008-0.207,0.027-0.336c0.021-0.158-0.059-0.316-0.199-0.391c-0.503-0.274-1.039-0.498-1.597-0.662c-0.154-0.044-0.32,0.01-0.416,0.137c-0.079,0.106-0.148,0.188-0.22,0.257C11.244,2.956,10.643,3.207,10,3.207c-0.642,0-1.244-0.25-1.697-0.704c-0.071-0.069-0.141-0.15-0.22-0.257C7.987,2.119,7.821,2.065,7.667,2.109C7.109,2.275,6.571,2.497,6.07,2.771C5.929,2.846,5.85,3.004,5.871,3.162c0.02,0.129,0.027,0.237,0.027,0.336c0,1.325-1.076,2.4-2.401,2.4c-0.098,0-0.206-0.007-0.335-0.027C3.001,5.851,2.845,5.929,2.77,6.07C2.496,6.572,2.274,7.109,2.108,7.667c-0.044,0.154,0.01,0.32,0.137,0.417c0.106,0.079,0.187,0.148,0.256,0.22c0.938,0.936,0.938,2.458,0,3.394c-0.069,0.072-0.15,0.141-0.256,0.221c-0.127,0.096-0.181,0.262-0.137,0.416c0.166,0.557,0.388,1.096,0.662,1.596c0.075,0.143,0.231,0.221,0.392,0.199c0.129-0.02,0.237-0.027,0.335-0.027c1.325,0,2.401,1.076,2.401,2.402c0,0.098-0.007,0.205-0.027,0.334C5.85,16.996,5.929,17.154,6.07,17.23c0.501,0.273,1.04,0.496,1.597,0.66c0.154,0.047,0.32-0.008,0.417-0.137c0.079-0.105,0.148-0.186,0.22-0.256c0.454-0.453,1.055-0.703,1.697-0.703c0.643,0,1.244,0.25,1.697,0.703c0.071,0.07,0.141,0.15,0.22,0.256c0.073,0.098,0.188,0.152,0.307,0.152c0.036,0,0.073-0.004,0.109-0.016c0.558-0.164,1.096-0.387,1.597-0.66c0.141-0.076,0.22-0.234,0.199-0.393c-0.02-0.129-0.027-0.236-0.027-0.334c0-1.326,1.076-2.402,2.401-2.402c0.098,0,0.206,0.008,0.336,0.027c0.159,0.021,0.315-0.057,0.391-0.199c0.274-0.5,0.496-1.039,0.662-1.596c0.044-0.154-0.01-0.32-0.137-0.416C17.648,11.838,17.567,11.77,17.498,11.697 M16.671,13.334c-0.059-0.002-0.114-0.002-0.168-0.002c-1.749,0-3.173,1.422-3.173,3.172c0,0.053,0.002,0.109,0.004,0.166c-0.312,0.158-0.64,0.295-0.976,0.406c-0.039-0.045-0.077-0.086-0.115-0.123c-0.601-0.6-1.396-0.93-2.243-0.93s-1.643,0.33-2.243,0.93c-0.039,0.037-0.077,0.078-0.116,0.123c-0.336-0.111-0.664-0.248-0.976-0.406c0.002-0.057,0.004-0.113,0.004-0.166c0-1.75-1.423-3.172-3.172-3.172c-0.054,0-0.11,0-0.168,0.002c-0.158-0.312-0.293-0.639-0.405-0.975c0.044-0.039,0.085-0.078,0.124-0.115c1.236-1.236,1.236-3.25,0-4.486C3.009,7.719,2.969,7.68,2.924,7.642c0.112-0.336,0.247-0.664,0.405-0.976C3.387,6.668,3.443,6.67,3.497,6.67c1.75,0,3.172-1.423,3.172-3.172c0-0.054-0.002-0.11-0.004-0.168c0.312-0.158,0.64-0.293,0.976-0.405C7.68,2.969,7.719,3.01,7.757,3.048c0.6,0.6,1.396,0.93,2.243,0.93s1.643-0.33,2.243-0.93c0.038-0.039,0.076-0.079,0.115-0.123c0.336,0.112,0.663,0.247,0.976,0.405c-0.002,0.058-0.004,0.114-0.004,0.168c0,1.749,1.424,3.172,3.173,3.172c0.054,0,0.109-0.002,0.168-0.004c0.158,0.312,0.293,0.64,0.405,0.976c-0.045,0.038-0.086,0.077-0.124,0.116c-0.6,0.6-0.93,1.396-0.93,2.242c0,0.847,0.33,1.645,0.93,2.244c0.038,0.037,0.079,0.076,0.124,0.115C16.964,12.695,16.829,13.021,16.671,13.334 M10,5.417c-2.528,0-4.584,2.056-4.584,4.583c0,2.529,2.056,4.584,4.584,4.584s4.584-2.055,4.584-4.584C14.584,7.472,12.528,5.417,10,5.417 M10,13.812c-2.102,0-3.812-1.709-3.812-3.812c0-2.102,1.71-3.812,3.812-3.812c2.102,0,3.812,1.71,3.812,3.812C13.812,12.104,12.102,13.812,10,13.812"></path></svg>
                  Settings
                </a>
              </li>

            </ul>
          </section>

        </nav>
      </header>

      <main class="content-wrap">
        <%= PageLive.render(@settings[:view], assigns) %>
      </main>

        </div>
        <style>

        body {
          color: #99a0b0;
          width: 100%;
          height: 100%;
          background: #151B22;<! -- f5f5fa -->
          font-size: 16px;
          line-height: 120%;
          font-family: Open Sans, Helvetica, sans-serif;
        }
        .dashboard {
          display: grid;
          width: 100%;
          height: 100%;
          grid-gap: 0;
          grid-template-columns: 320px auto;
          grid-template-rows: 80px auto;
          grid-template-areas: 'menu search' 'menu content';
        }
        .search-wrap {
          grid-area: search;
          background: #1D2E44; <!-- fff-->
          border-bottom: 1px solid #ede8f0;
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0 3em;
        }
        .search-wrap .search {
          height: 40px;
        }
        .search-wrap .search label {
          display: flex;
          align-items: center;
          height: 100%;
        }
        .search-wrap .search label svg {
          display: block;
        }
        .search-wrap .search label svg path,
        .search-wrap .search label svg circle {
          fill: #b6bbc6;
          transition: fill 0.15s ease;
        }
        .search-wrap .search label input {
          display: block;
          padding-left: 1em;
          height: 100%;
          margin: 0;
          border: 0;
        }
        .search-wrap .search label input:focus {
          background: #f5f5fa;
        }
        .search-wrap .search label:hover svg path,
        .search-wrap .search label:hover svg circle {
          fill: #2b3a60;
        }
        .search-wrap .user-actions button {
          border: 0;
          background: none;
          width: 32px;
          height: 32px;
          margin: 0;
          padding: 0;
          margin-left: 0.5em;
        }
        .search-wrap .user-actions button svg {
          position: relative;
          top: 2px;
        }
        .search-wrap .user-actions button svg path,
        .search-wrap .user-actions button svg circle {
          fill: #b6bbc6;
          transition: fill 0.15s ease;
        }
        .search-wrap .user-actions button:hover svg path,
        .search-wrap .user-actions button:hover svg circle {
          fill: #00FFC3;
        }
        .menu-wrap {
          grid-area: menu;
          padding-bottom: 3em;
          overflow: auto;
          background: #1D2E44; <!-- #fff -->
          border-right: 1px solid #ede8f0;
        }
        .menu-wrap .user {
          height: 200px;
          display: flex;
          align-items: center;
          justify-content: flex-start;
          margin: 0;
          padding: 0 3em;
        }
        .menu-wrap .user .user-avatar {
          width: 110px;
          height: 70px;
          border-radius: 100%;
        }
        .menu-wrap .user .user-avatar img {
          display: block;
          width: 100%;
          height: 90%;
          # -o-object-fit: cover;
          #    object-fit: cover;
        }
        .menu-wrap .user figcaption {
          margin: 3;
          padding: 0 0 0 0.5em;
          color: #fff; <!--516F91 1b253d  -->
          font-weight: 900;
          font-size: 1.3em;
          line-height: 130%;
        }
        .menu-wrap nav {
          display: block;
          padding: 0 3em;
        }
        .menu-wrap nav section {
          display: block;
          padding: 3em 0 0;
        }
        .menu-wrap nav a {
          margin: 0;
          font-size: 1.675em;
          text-transform: uppercase;
          color: #fff;
          font-weight: 900;
          transition: color 0.4s ease;
        }

        .menu-wrap nav a:hover {
          color: #00FFC3;
        }

        .menu-wrap nav h3 {
          margin: 0;
          font-size: 1.675em;
          text-transform: uppercase;
          color: #fff;
          font-weight: 900;
        }
        .menu-wrap nav ul {
          display: block;
          padding: 0;
          margin: 2;
        }
        .menu-wrap nav li {
          display: block;
          padding: 0;
          margin: 1.4em 0 0;
        }
        .menu-wrap nav li a {
          display: flex;
          align-items: center;
          justify-content: flex-start;
          color: #99a0b0;
          text-decoration: none;
          font-weight: 600;
          font-size: 1.475em;
          transition: color 0.4s ease;
        }
        .menu-wrap nav li a svg {
          display: block;
          margin-right: 1em;
        }
        .menu-wrap nav li a svg path,
        .menu-wrap nav li a svg circle {
          fill: #b6bbc6;
          transition: fill 0.15s ease;
        }
        .menu-wrap nav li a:hover {
          color: #00FFC3;
        }
        .menu-wrap nav li a:hover svg path,
        .menu-wrap nav li a:hover svg circle {
          fill: #00FFC3;
        }
        .menu-wrap nav li a.active {
          color: #4b84fe;
        }
        .menu-wrap nav li a.active svg path,
        .menu-wrap nav li a.active svg circle {
          fill: #4b84fe;
        }
        .content-wrap {
          grid-area: content;
          padding: 3em;
          overflow: auto;
        }
        .content-wrap .content-head {
          display: flex;
          align-items: center;
          justify-content: space-between;
        }
        .content-wrap .content-head h1 {
          font-size: 2.175em;
          line-height: 100%;
          color: #fff; <!-- #1b253d -->
          font-weight: 500;
          margin: 0;
          padding: 0;
        }
        .content-wrap .content-head .action button {
          border: 0;
          background: #4b84fe;
          color: #fff;
          width: auto;
          height: 3.5em;
          padding: 0 2.25em;
          border-radius: 3.5em;
          font-size: 1em;
          text-transform: uppercase;
          font-weight: 600;
          transition: background-color 0.15s ease;
        }
        .content-wrap .content-head .action button:hover {
          background-color: #1861fe;
        }
        .content-wrap .content-head .action button:hover:active {
          background-color: #00FFC3;
          transition: none;
        }
        .content-wrap .info-boxes {
          padding: 3em 0 2em;
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
          grid-gap: 2em;
        }
        .content-wrap .info-boxes .info-box {
          background: #F4F6F7;
          height: 160px;
          display: flex;
          align-items: center;
          justify-content: flex-start;
          padding: 0 3em;
          border: 1px solid #ede8f0;
          border-radius: 20px;
        }
        .content-wrap .info-boxes .info-box .box-icon svg {
          display: block;
          width: 48px;
          height: 48px;
        }
        .content-wrap .info-boxes .info-box .box-icon svg path,
        .content-wrap .info-boxes .info-box .box-icon svg circle {
          fill: #99a0b0;
        }
        .content-wrap .info-boxes .info-box .box-content {
          padding-left: 1.25em;
          white-space: nowrap;
        }
        .content-wrap .info-boxes .info-box .box-content .big {
          display: block;
          font-size: 2em;
          line-height: 150%;
          color: #1b253d;
        }

        .content-wrap .info-boxes .info-box .box-content .medium {
          display: block;
          font-size: 1.5em;
          line-height: 150%;
          color: #1b253d;
        }

        .content-wrap .info-boxes .info-box .box-content .small {
          width: 50px;
          display: block;
          font-size: 0.6em;
          line-height: 150%;
          word-wrap: break-word;
          color: #1b253d;
        }

        .content-wrap .info-boxes .info-box.active svg circle,
        .content-wrap .info-boxes .info-box.active svg path {
          fill: #4b84fe;
        }
        .content-wrap .chart-boxes {
          padding: 0;
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
          grid-gap: 2em;
        }
        .content-wrap .chart-boxes .chart-box {
          background: #F4F6F7;
          height: 320px;
          text-align: center;
          padding: 1em;
          border: 1px solid #ede8f0;
          border-radius: 20px;
        }
        .content-wrap .chart-boxes .chart-box:nth-child(2n) .box-avatar .no-name {
          background: #4b84fe;
        }
        .content-wrap .chart-boxes .chart-box:nth-child(5n) .box-avatar .no-name {
          background: #ffbb09;
        }
        .content-wrap .chart-boxes .chart-box .box-avatar {
          width: 100px;
          height: 100px;
          border-radius: 50%;
          margin: 0px auto;
          overflow: hidden;
        }
        .content-wrap .chart-boxes .chart-box .box-avatar img {
          display: block;
          width: 100%;
          height: 100%;
          -o-object-fit: cover;
            object-fit: cover;
        }
        .content-wrap .chart-boxes .chart-box .box-avatar .no-name {
          display: flex;
          align-items: center;
          justify-content: center;
          text-align: center;
          color: #fff;
          font-size: 1.5em;
          font-weight: 600;
          text-transform: uppercase;
          width: 100%;
          height: 100%;
          background: #fa5b67;
        }
        .content-wrap .chart-boxes .chart-box .box-bio {
          white-space: no-wrap;
        }
        .content-wrap .chart-boxes .chart-box .box-bio .bio-name {
          margin: 2em 0 0.75em;
          color: #1b253d;
          font-size: 1em;
          font-weight: 700;
          line-height: 100%;
        }
        .content-wrap .chart-boxes .chart-box .box-bio .bio-position {
          margin: 0;
          font-size: 0.875em;
          line-height: 100%;
        }
        .content-wrap .chart-boxes .chart-box .box-actions {
          margin-top: 1.25em;
          padding-top: 1.25em;
          width: 100%;
          border-top: 1px solid #ede8f0;
          display: flex;
          align-items: center;
          justify-content: space-between;
        }
        .content-wrap .chart-boxes .chart-box .box-actions button {
          border: 0;
          background: none;
          width: 32px;
          height: 32px;
          margin: 0;
          padding: 0;
        }
        .content-wrap .chart-boxes .chart-box .box-actions button svg {
          position: relative;
          top: 2px;
        }
        .content-wrap .chart-boxes .chart-box .box-actions button svg path,
        .content-wrap .chart-boxes .chart-box .box-actions button svg circle {
          fill: #b6bbc6;
          transition: fill 0.15s ease;
        }
        .content-wrap .chart-boxes .chart-box .box-actions button:hover svg path,
        .content-wrap .chart-boxes .chart-box .box-actions button:hover svg circle {
          fill: #2b3a60;
        }


        /* Dropdown Button */
        .dropbtn {
        background-color: #4b84fe;
        color: white;
        padding: 16px;
        font-size: 16px;
        border: none;
        }

        /* The container <div> - needed to position the dropdown content */
        .dropdown {
        position: relative;
        display: inline-block;
        }

        /* Dropdown Content (Hidden by Default) */
        .dropdown-content {
        display: none;
        position: absolute;
        background-color: #f1f1f1;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        z-index: 1;
        }

        /* Links inside the dropdown */
        .dropdown-content a {
        color: black;
        padding: 12px 16px;
        text-decoration: none;
        display: block;
        }

        /* Change color of dropdown links on hover */
        .dropdown-content a:hover {background-color: #ddd;}

        /* Show the dropdown menu on hover */
        .dropdown:hover .dropdown-content {display: block;}

        /* Change the background color of the dropdown button when the dropdown content is shown */
        .dropdown:hover .dropbtn {background-color: #1861fe;
;}
      </style>
    """
  end
end
