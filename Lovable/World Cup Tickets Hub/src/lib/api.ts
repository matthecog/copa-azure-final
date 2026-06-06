// Configuração da API para conectar ao backend Node.js/Express
// Em produção usa URLs relativas (/api), em dev usa localhost:3001

const API_BASE_URL = import.meta.env.VITE_API_URL || '/api';

interface ApiResponse<T> {
  data?: T;
  error?: string;
}

export interface StandingRow {
  team_id: number;
  team_name: string;
  team_code: string;
  team_flag: string;
  played: number;
  won: number;
  drawn: number;
  lost: number;
  gf: number;
  ga: number;
  gd: number;
  points: number;
}

export interface BracketSlot {
  team_id?: number;
  team_code?: string;
  team_name?: string;
  team_flag?: string;
  label: string;
}

export interface BracketMatch {
  match_id: number;
  match_number: number;
  slot1: BracketSlot;
  slot2: BracketSlot;
  score1: number | null;
  score2: number | null;
  status: string;
  date: string | null;
  time: string | null;
  stadium_name: string | null;
  stadium_city: string | null;
}

export interface BracketResponse {
  bracket: {
    round_of_32: BracketMatch[];
    round_of_16: BracketMatch[];
    quarter_final: BracketMatch[];
    semi_final: BracketMatch[];
    third_place: BracketMatch | null;
    final: BracketMatch | null;
  };
}

// ---------------------------------------------------------------------------
// Formas canônicas das entidades retornadas pelo backend.
// São supersets das interfaces locais usadas nas páginas/consumidores, então
// o resultado da API é atribuível diretamente a qualquer interface local.
// ---------------------------------------------------------------------------

export interface Pagination {
  page: number;
  pageSize: number;
  total: number;
  totalPages: number;
}

export interface ApiUser {
  id: number;
  name: string;
  email: string;
  role: string;
  created_at: string;
  createdAt?: string;
  phone?: string;
  cpf?: string;
}

export interface Match {
  id: number;
  date: string;
  time: string;
  stage: string;
  group_name: string | null;
  home_team_id: number;
  away_team_id: number;
  stadium_id: number;
  home_score: number | null;
  away_score: number | null;
  status: string;
  home_team_name: string;
  home_team_code: string;
  home_team_flag: string;
  home_team_confederation?: string;
  away_team_name: string;
  away_team_code: string;
  away_team_flag: string;
  away_team_confederation?: string;
  stadium_name: string;
  stadium_city: string;
}

export interface Stadium {
  id: number;
  name: string;
  city: string;
  country: string;
  capacity: number;
  image: string | null;
  description: string | null;
  inauguration_year: number | null;
  latitude: number | null;
  longitude: number | null;
}

export interface Team {
  id: number;
  name: string;
  code: string;
  flag: string;
  group_name: string | null;
  confederation?: string;
}

export interface MatchTicket {
  id: number;
  category: string;
  price: number;
  available_quantity: number;
  sold_quantity: number;
}

export interface MyTicket {
  id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
  status: string;
  created_at: string;
  category: string;
  match_date: string;
  match_time: string;
  stage: string;
  home_team: string;
  home_team_flag: string;
  away_team: string;
  away_team_flag: string;
  stadium_name: string;
  stadium_city: string;
}

export interface Sale {
  id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
  status: string;
  created_at: string;
  user_id: number;
  user_name: string;
  user_email: string;
  category: string;
  match_id: number;
  match_date: string;
  match_time: string;
  stage: string;
  home_team: string;
  home_team_code: string;
  home_team_flag?: string;
  away_team: string;
  away_team_code: string;
  away_team_flag?: string;
  stadium_name: string;
  stadium_city: string;
  stadium_country?: string;
}

export interface AdminStats {
  total_users: number;
  total_sales: number;
  total_revenue: number;
  total_tickets_sold: number;
  total_matches: number;
  total_stadiums: number;
}

class ApiClient {
  private baseUrl: string;
  private token: string | null = null;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
    this.token = localStorage.getItem('auth_token');
  }

  setToken(token: string | null) {
    this.token = token;
    if (token) {
      localStorage.setItem('auth_token', token);
    } else {
      localStorage.removeItem('auth_token');
    }
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> {
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      ...options.headers,
    };

    if (this.token) {
      headers['Authorization'] = `Bearer ${this.token}`;
    }

    try {
      const response = await fetch(`${this.baseUrl}${endpoint}`, {
        ...options,
        headers,
      });

      const contentType = response.headers.get('content-type') || '';
      let payload: unknown = null;

      if (contentType.includes('application/json')) {
        payload = await response.json();
      } else {
        const text = await response.text();
        try {
          payload = JSON.parse(text);
        } catch {
          payload = { error: text };
        }
      }

      if (!response.ok) {
        const errPayload = payload as { error?: string } | null;
        return { error: errPayload?.error || `Erro na requisição (${response.status})` };
      }

      return { data: payload as T };
    } catch (error) {
      console.error('API Error:', error);
      return { error: 'Erro de conexão com o servidor' };
    }
  }

  // Auth
  async login(email: string, password: string) {
    const result = await this.request<{ user: ApiUser; token: string }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });

    if (result.data?.token) {
      this.setToken(result.data.token);
    }

    return result;
  }

  async register(name: string, email: string, password: string) {
    const result = await this.request<{ user: ApiUser; token: string }>('/auth/register', {
      method: 'POST',
      body: JSON.stringify({ name, email, password }),
    });

    if (result.data?.token) {
      this.setToken(result.data.token);
    }

    return result;
  }

  async getMe() {
    return this.request<{ user: ApiUser }>('/auth/me');
  }

  logout() {
    this.setToken(null);
  }

  // Matches
  async getMatches(params?: { stage?: string; stadium_id?: string }) {
    const query = params ? '?' + new URLSearchParams(params as Record<string, string>).toString() : '';
    return this.request<{ matches: Match[] }>(`/matches${query}`);
  }

  async getMatch(id: string) {
    return this.request<{ match: Match }>(`/matches/${id}`);
  }

  async getMatchTickets(id: string) {
    return this.request<{ tickets: MatchTicket[] }>(`/matches/${id}/tickets`);
  }

  // Stadiums
  async getStadiums(params?: { country?: string }) {
    const query = params ? '?' + new URLSearchParams(params as Record<string, string>).toString() : '';
    return this.request<{ stadiums: Stadium[] }>(`/stadiums${query}`);
  }

  async getStadium(id: string) {
    return this.request<{ stadium: Stadium }>(`/stadiums/${id}`);
  }

  async getStadiumMatches(id: string) {
    return this.request<{ matches: Match[] }>(`/stadiums/${id}/matches`);
  }

  // Teams
  async getTeams(params?: { confederation?: string; group_name?: string }) {
    const query = params ? '?' + new URLSearchParams(params as Record<string, string>).toString() : '';
    return this.request<{ teams: Team[] }>(`/teams${query}`);
  }

  async getTeam(id: string) {
    return this.request<{ team: Team }>(`/teams/${id}`);
  }

  async getGroups() {
    return this.request<{ groups: Team[] }>('/teams/groups');
  }

  // Standings (tabela da Copa)
  async getStandings() {
    return this.request<{ standings: Record<string, StandingRow[]> }>('/standings');
  }

  // Bracket (mata-mata)
  async getBracket() {
    return this.request<BracketResponse>('/bracket');
  }

  // Tickets
  async purchaseTickets(items: { ticket_category_id: number; quantity: number }[]) {
    return this.request<{ message: string; total_amount: number; tickets: MyTicket[] }>('/tickets/purchase', {
      method: 'POST',
      body: JSON.stringify({ items }),
    });
  }

  async getMyTickets() {
    return this.request<{ tickets: MyTicket[] }>('/tickets/my-tickets');
  }

  // User
  async updateProfile(data: { name: string }) {
    return this.request<{ user: ApiUser }>('/users/profile', {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async updatePassword(currentPassword: string, newPassword: string) {
    return this.request<{ message: string }>('/users/password', {
      method: 'PUT',
      body: JSON.stringify({ currentPassword, newPassword }),
    });
  }

  // Admin - Users
  async getUsers(params?: { page?: number; pageSize?: number; search?: string; role?: string }) {
    const cleanParams: Record<string, string> = {};
    if (params) {
      Object.entries(params).forEach(([k, v]) => {
        if (v !== undefined && v !== null && v !== '') cleanParams[k] = String(v);
      });
    }
    const q = Object.keys(cleanParams).length > 0 ? '?' + new URLSearchParams(cleanParams).toString() : '';
    return this.request<{
      users: ApiUser[];
      pagination?: Pagination;
    }>(`/users${q}`);
  }

  // Admin - Matches
  async createMatch(data: { home_team_id: number; away_team_id: number; stadium_id: number; date: string; time: string; stage: string; group_name?: string }) {
    return this.request<{ match: Match; message: string }>('/matches', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  async updateMatch(id: number, data: { home_team_id: number; away_team_id: number; stadium_id: number; date: string; time: string; stage: string; group_name?: string; home_score?: number; away_score?: number; status?: string }) {
    return this.request<{ match: Match; message: string }>(`/matches/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async deleteMatch(id: number) {
    return this.request<{ message: string }>(`/matches/${id}`, {
      method: 'DELETE',
    });
  }

  // Admin - Stadiums
  async createStadium(data: { name: string; city: string; country: string; capacity: number; image?: string; description?: string }) {
    return this.request<{ stadium: Stadium; message: string }>('/stadiums', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  async updateStadium(id: number, data: { name: string; city: string; country: string; capacity: number; image?: string; description?: string }) {
    return this.request<{ stadium: Stadium; message: string }>(`/stadiums/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  async deleteStadium(id: number) {
    return this.request<{ message: string }>(`/stadiums/${id}`, {
      method: 'DELETE',
    });
  }

  // Admin - Sales (paginated)
  async getSales(params?: {
    page?: number;
    pageSize?: number;
    status?: string;
    search?: string;
    start_date?: string;
    end_date?: string;
  }) {
    const cleanParams: Record<string, string> = {};
    if (params) {
      Object.entries(params).forEach(([k, v]) => {
        if (v !== undefined && v !== null && v !== '') cleanParams[k] = String(v);
      });
    }
    const q = Object.keys(cleanParams).length > 0 ? '?' + new URLSearchParams(cleanParams).toString() : '';
    return this.request<{
      sales: Sale[];
      pagination?: Pagination;
    }>(`/admin/sales${q}`);
  }

  async getSale(id: number) {
    return this.request<{ sale: Sale }>(`/admin/sales/${id}`);
  }

  async getAdminStats() {
    return this.request<{ stats: AdminStats }>('/admin/stats');
  }

  // Health check
  async healthCheck() {
    return this.request<{ status: string; timestamp: string }>('/health');
  }
}

export const api = new ApiClient(API_BASE_URL);
export default api;
