--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0
-- Dumped by pg_dump version 13.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO nnrfc;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO nnrfc;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO nnrfc;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO nnrfc;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO nnrfc;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO nnrfc;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: axes_accessattempt; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.axes_accessattempt (
    id integer NOT NULL,
    user_agent character varying(255) NOT NULL,
    ip_address inet,
    username character varying(255),
    http_accept character varying(1025) NOT NULL,
    path_info character varying(255) NOT NULL,
    attempt_time timestamp with time zone NOT NULL,
    get_data text NOT NULL,
    post_data text NOT NULL,
    failures_since_start integer NOT NULL,
    CONSTRAINT axes_accessattempt_failures_since_start_check CHECK ((failures_since_start >= 0))
);


ALTER TABLE public.axes_accessattempt OWNER TO nnrfc;

--
-- Name: axes_accessattempt_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.axes_accessattempt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.axes_accessattempt_id_seq OWNER TO nnrfc;

--
-- Name: axes_accessattempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.axes_accessattempt_id_seq OWNED BY public.axes_accessattempt.id;


--
-- Name: axes_accesslog; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.axes_accesslog (
    id integer NOT NULL,
    user_agent character varying(255) NOT NULL,
    ip_address inet,
    username character varying(255),
    http_accept character varying(1025) NOT NULL,
    path_info character varying(255) NOT NULL,
    attempt_time timestamp with time zone NOT NULL,
    logout_time timestamp with time zone
);


ALTER TABLE public.axes_accesslog OWNER TO nnrfc;

--
-- Name: axes_accesslog_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.axes_accesslog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.axes_accesslog_id_seq OWNER TO nnrfc;

--
-- Name: axes_accesslog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.axes_accesslog_id_seq OWNED BY public.axes_accesslog.id;


--
-- Name: core_answer; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_answer (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    month integer,
    value character varying(150) NOT NULL,
    fill_survey_id bigint,
    option_id bigint NOT NULL,
    created_by_id bigint,
    created_by_level_id bigint,
    fiscal_year_id bigint
);


ALTER TABLE public.core_answer OWNER TO nnrfc;

--
-- Name: core_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_answer_id_seq OWNER TO nnrfc;

--
-- Name: core_answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_answer_id_seq OWNED BY public.core_answer.id;


--
-- Name: core_answerdocument; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_answerdocument (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    document character varying(100) NOT NULL,
    answer_id bigint NOT NULL
);


ALTER TABLE public.core_answerdocument OWNER TO nnrfc;

--
-- Name: core_answerdocument_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_answerdocument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_answerdocument_id_seq OWNER TO nnrfc;

--
-- Name: core_answerdocument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_answerdocument_id_seq OWNED BY public.core_answerdocument.id;


--
-- Name: core_appraisalreviewrequest; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_appraisalreviewrequest (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    subject character varying(200),
    score_obtained double precision,
    reason text,
    expected_score double precision,
    file_upload character varying(100),
    question_id_id bigint,
    is_checked boolean NOT NULL,
    level_id bigint,
    user_id bigint
);


ALTER TABLE public.core_appraisalreviewrequest OWNER TO nnrfc;

--
-- Name: core_appraisalreviewrequest_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_appraisalreviewrequest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_appraisalreviewrequest_id_seq OWNER TO nnrfc;

--
-- Name: core_appraisalreviewrequest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_appraisalreviewrequest_id_seq OWNED BY public.core_appraisalreviewrequest.id;


--
-- Name: core_centralbody; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_centralbody (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(50) NOT NULL,
    name_np character varying(50)
);


ALTER TABLE public.core_centralbody OWNER TO nnrfc;

--
-- Name: core_centralbody_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_centralbody_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_centralbody_id_seq OWNER TO nnrfc;

--
-- Name: core_centralbody_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_centralbody_id_seq OWNED BY public.core_centralbody.id;


--
-- Name: core_complaint; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_complaint (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    sub character varying(50) NOT NULL,
    msg text NOT NULL,
    is_checked boolean NOT NULL,
    level_id bigint NOT NULL,
    user_id bigint,
    complaint_file character varying(100)
);


ALTER TABLE public.core_complaint OWNER TO nnrfc;

--
-- Name: core_complaint_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_complaint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_complaint_id_seq OWNER TO nnrfc;

--
-- Name: core_complaint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_complaint_id_seq OWNED BY public.core_complaint.id;


--
-- Name: core_correctionactivitylog; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_correctionactivitylog (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_name character varying(255) NOT NULL,
    user_email character varying(254) NOT NULL,
    user_level character varying(100),
    action_level character varying(100),
    action_level_type character varying(1),
    option character varying(255),
    old_value character varying(255),
    changed_value character varying(255),
    activity character varying(500) NOT NULL,
    option_id bigint,
    question_id bigint,
    question_title character varying(500),
    CONSTRAINT core_correctionactivitylog_option_id_check CHECK ((option_id >= 0)),
    CONSTRAINT core_correctionactivitylog_question_id_check CHECK ((question_id >= 0))
);


ALTER TABLE public.core_correctionactivitylog OWNER TO nnrfc;

--
-- Name: core_correctionactivitylog_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_correctionactivitylog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_correctionactivitylog_id_seq OWNER TO nnrfc;

--
-- Name: core_correctionactivitylog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_correctionactivitylog_id_seq OWNED BY public.core_correctionactivitylog.id;


--
-- Name: core_fillsurvey; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_fillsurvey (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    budget_period character varying(10),
    approval_state character varying(20),
    created_by_id bigint,
    survey_id bigint NOT NULL,
    level_id_id bigint
);


ALTER TABLE public.core_fillsurvey OWNER TO nnrfc;

--
-- Name: core_fillsurvey_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_fillsurvey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_fillsurvey_id_seq OWNER TO nnrfc;

--
-- Name: core_fillsurvey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_fillsurvey_id_seq OWNED BY public.core_fillsurvey.id;


--
-- Name: core_fiscalyear; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_fiscalyear (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(50) NOT NULL,
    start_date date,
    end_date date,
    end_date_bs character varying(20),
    start_date_bs character varying(20),
    active_fy boolean NOT NULL
);


ALTER TABLE public.core_fiscalyear OWNER TO nnrfc;

--
-- Name: core_fiscalyear_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_fiscalyear_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_fiscalyear_id_seq OWNER TO nnrfc;

--
-- Name: core_fiscalyear_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_fiscalyear_id_seq OWNED BY public.core_fiscalyear.id;


--
-- Name: core_localbody; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_localbody (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(50) NOT NULL,
    name_np character varying(50),
    province_id bigint
);


ALTER TABLE public.core_localbody OWNER TO nnrfc;

--
-- Name: core_localbody_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_localbody_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_localbody_id_seq OWNER TO nnrfc;

--
-- Name: core_localbody_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_localbody_id_seq OWNED BY public.core_localbody.id;


--
-- Name: core_notification; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_notification (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    msg character varying(255) NOT NULL,
    is_viewed boolean NOT NULL,
    correction_id bigint,
    user_id bigint,
    level_id bigint,
    question_id bigint,
    correction_checked boolean NOT NULL
);


ALTER TABLE public.core_notification OWNER TO nnrfc;

--
-- Name: core_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_notification_id_seq OWNER TO nnrfc;

--
-- Name: core_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_notification_id_seq OWNED BY public.core_notification.id;


--
-- Name: core_option; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_option (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    title character varying(500) NOT NULL,
    field_type character varying(2) NOT NULL,
    is_calc_field boolean NOT NULL,
    created_by_id bigint,
    question_id bigint NOT NULL,
    option_type character varying(5),
    sequence_id integer,
    CONSTRAINT core_option_sequence_id_check CHECK ((sequence_id >= 0))
);


ALTER TABLE public.core_option OWNER TO nnrfc;

--
-- Name: core_option_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_option_id_seq OWNER TO nnrfc;

--
-- Name: core_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_option_id_seq OWNED BY public.core_option.id;


--
-- Name: core_provincebody; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_provincebody (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(50) NOT NULL,
    name_np character varying(50),
    central_id bigint
);


ALTER TABLE public.core_provincebody OWNER TO nnrfc;

--
-- Name: core_provincebody_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_provincebody_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_provincebody_id_seq OWNER TO nnrfc;

--
-- Name: core_provincebody_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_provincebody_id_seq OWNED BY public.core_provincebody.id;


--
-- Name: core_question; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_question (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    title character varying(500) NOT NULL,
    is_document_required boolean NOT NULL,
    month_requires boolean NOT NULL,
    sequence_id integer,
    parent_id bigint,
    survey_id bigint NOT NULL,
    is_options_created boolean NOT NULL,
    department_id bigint,
    CONSTRAINT core_question_sequence_id_check CHECK ((sequence_id >= 0))
);


ALTER TABLE public.core_question OWNER TO nnrfc;

--
-- Name: core_question_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_question_id_seq OWNER TO nnrfc;

--
-- Name: core_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_question_id_seq OWNED BY public.core_question.id;


--
-- Name: core_survey; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_survey (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100),
    level character varying(1) NOT NULL,
    approval_state character varying(1) NOT NULL,
    is_active boolean NOT NULL,
    fiscal_year_id bigint NOT NULL
);


ALTER TABLE public.core_survey OWNER TO nnrfc;

--
-- Name: core_survey_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_survey_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_survey_id_seq OWNER TO nnrfc;

--
-- Name: core_survey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_survey_id_seq OWNED BY public.core_survey.id;


--
-- Name: core_surveycorrection; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.core_surveycorrection (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    sub character varying(255) NOT NULL,
    msg text NOT NULL,
    document character varying(100),
    status character varying(1) NOT NULL,
    question_id bigint NOT NULL,
    user_id bigint,
    level_id bigint,
    month smallint,
    CONSTRAINT core_surveycorrection_month_check CHECK ((month >= 0))
);


ALTER TABLE public.core_surveycorrection OWNER TO nnrfc;

--
-- Name: core_surveycorrection_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.core_surveycorrection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_surveycorrection_id_seq OWNER TO nnrfc;

--
-- Name: core_surveycorrection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.core_surveycorrection_id_seq OWNED BY public.core_surveycorrection.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id bigint NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO nnrfc;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO nnrfc;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO nnrfc;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO nnrfc;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO nnrfc;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO nnrfc;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO nnrfc;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO nnrfc;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.django_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO nnrfc;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- Name: user_mgmt_department; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_department (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(100),
    email character varying(254)
);


ALTER TABLE public.user_mgmt_department OWNER TO nnrfc;

--
-- Name: user_mgmt_department_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_department_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_department_id_seq OWNED BY public.user_mgmt_department.id;


--
-- Name: user_mgmt_district; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_district (
    id bigint NOT NULL,
    name_eng character varying(150) NOT NULL,
    name_np character varying(150) NOT NULL,
    code character varying(15)
);


ALTER TABLE public.user_mgmt_district OWNER TO nnrfc;

--
-- Name: user_mgmt_district_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_district_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_district_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_district_id_seq OWNED BY public.user_mgmt_district.id;


--
-- Name: user_mgmt_level; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_level (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    type_id bigint,
    province_level_id bigint,
    level_code character varying(50),
    district_id bigint
);


ALTER TABLE public.user_mgmt_level OWNER TO nnrfc;

--
-- Name: user_mgmt_level_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_level_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_level_id_seq OWNED BY public.user_mgmt_level.id;


--
-- Name: user_mgmt_leveltype; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_leveltype (
    id bigint NOT NULL,
    type character varying(1) NOT NULL
);


ALTER TABLE public.user_mgmt_leveltype OWNER TO nnrfc;

--
-- Name: user_mgmt_leveltype_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_leveltype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_leveltype_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_leveltype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_leveltype_id_seq OWNED BY public.user_mgmt_leveltype.id;


--
-- Name: user_mgmt_menu; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_menu (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    code character varying(50) NOT NULL,
    order_id smallint,
    url character varying(100) NOT NULL,
    ic_class character varying(50),
    parent_id bigint,
    CONSTRAINT user_mgmt_menu_order_id_check CHECK ((order_id >= 0))
);


ALTER TABLE public.user_mgmt_menu OWNER TO nnrfc;

--
-- Name: user_mgmt_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_menu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_menu_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_menu_id_seq OWNED BY public.user_mgmt_menu.id;


--
-- Name: user_mgmt_menupermission; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_menupermission (
    id bigint NOT NULL,
    can_add boolean NOT NULL,
    can_change boolean NOT NULL,
    can_view boolean NOT NULL,
    can_delete boolean NOT NULL,
    can_approve boolean NOT NULL,
    menu_id bigint NOT NULL,
    role_id bigint
);


ALTER TABLE public.user_mgmt_menupermission OWNER TO nnrfc;

--
-- Name: user_mgmt_menupermission_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_menupermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_menupermission_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_menupermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_menupermission_id_seq OWNED BY public.user_mgmt_menupermission.id;


--
-- Name: user_mgmt_role; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_role (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(50) NOT NULL,
    "desc" text
);


ALTER TABLE public.user_mgmt_role OWNER TO nnrfc;

--
-- Name: user_mgmt_role_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_role_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_role_id_seq OWNED BY public.user_mgmt_role.id;


--
-- Name: user_mgmt_role_menus; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_role_menus (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    menu_id bigint NOT NULL
);


ALTER TABLE public.user_mgmt_role_menus OWNER TO nnrfc;

--
-- Name: user_mgmt_role_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_role_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_role_menus_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_role_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_role_menus_id_seq OWNED BY public.user_mgmt_role_menus.id;


--
-- Name: user_mgmt_user; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_user (
    id bigint NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    is_first_login boolean NOT NULL,
    department_id bigint,
    address character varying(50),
    mobile_num character varying(12),
    full_name character varying(100),
    designation character varying(50),
    level_id bigint,
    personal_email character varying(254),
    post_id bigint,
    is_office_head boolean NOT NULL
);


ALTER TABLE public.user_mgmt_user OWNER TO nnrfc;

--
-- Name: user_mgmt_user_groups; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_user_groups (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.user_mgmt_user_groups OWNER TO nnrfc;

--
-- Name: user_mgmt_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_user_groups_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_user_groups_id_seq OWNED BY public.user_mgmt_user_groups.id;


--
-- Name: user_mgmt_user_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_user_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_user_id_seq OWNED BY public.user_mgmt_user.id;


--
-- Name: user_mgmt_user_roles; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_user_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.user_mgmt_user_roles OWNER TO nnrfc;

--
-- Name: user_mgmt_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_user_roles_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_user_roles_id_seq OWNED BY public.user_mgmt_user_roles.id;


--
-- Name: user_mgmt_user_user_permissions; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_user_user_permissions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.user_mgmt_user_user_permissions OWNER TO nnrfc;

--
-- Name: user_mgmt_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_user_user_permissions_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_user_user_permissions_id_seq OWNED BY public.user_mgmt_user_user_permissions.id;


--
-- Name: user_mgmt_userpost; Type: TABLE; Schema: public; Owner: nnrfc
--

CREATE TABLE public.user_mgmt_userpost (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.user_mgmt_userpost OWNER TO nnrfc;

--
-- Name: user_mgmt_userpost_id_seq; Type: SEQUENCE; Schema: public; Owner: nnrfc
--

CREATE SEQUENCE public.user_mgmt_userpost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_mgmt_userpost_id_seq OWNER TO nnrfc;

--
-- Name: user_mgmt_userpost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nnrfc
--

ALTER SEQUENCE public.user_mgmt_userpost_id_seq OWNED BY public.user_mgmt_userpost.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: axes_accessattempt id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.axes_accessattempt ALTER COLUMN id SET DEFAULT nextval('public.axes_accessattempt_id_seq'::regclass);


--
-- Name: axes_accesslog id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.axes_accesslog ALTER COLUMN id SET DEFAULT nextval('public.axes_accesslog_id_seq'::regclass);


--
-- Name: core_answer id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer ALTER COLUMN id SET DEFAULT nextval('public.core_answer_id_seq'::regclass);


--
-- Name: core_answerdocument id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answerdocument ALTER COLUMN id SET DEFAULT nextval('public.core_answerdocument_id_seq'::regclass);


--
-- Name: core_appraisalreviewrequest id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_appraisalreviewrequest ALTER COLUMN id SET DEFAULT nextval('public.core_appraisalreviewrequest_id_seq'::regclass);


--
-- Name: core_centralbody id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_centralbody ALTER COLUMN id SET DEFAULT nextval('public.core_centralbody_id_seq'::regclass);


--
-- Name: core_complaint id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_complaint ALTER COLUMN id SET DEFAULT nextval('public.core_complaint_id_seq'::regclass);


--
-- Name: core_correctionactivitylog id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_correctionactivitylog ALTER COLUMN id SET DEFAULT nextval('public.core_correctionactivitylog_id_seq'::regclass);


--
-- Name: core_fillsurvey id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fillsurvey ALTER COLUMN id SET DEFAULT nextval('public.core_fillsurvey_id_seq'::regclass);


--
-- Name: core_fiscalyear id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fiscalyear ALTER COLUMN id SET DEFAULT nextval('public.core_fiscalyear_id_seq'::regclass);


--
-- Name: core_localbody id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_localbody ALTER COLUMN id SET DEFAULT nextval('public.core_localbody_id_seq'::regclass);


--
-- Name: core_notification id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_notification ALTER COLUMN id SET DEFAULT nextval('public.core_notification_id_seq'::regclass);


--
-- Name: core_option id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_option ALTER COLUMN id SET DEFAULT nextval('public.core_option_id_seq'::regclass);


--
-- Name: core_provincebody id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_provincebody ALTER COLUMN id SET DEFAULT nextval('public.core_provincebody_id_seq'::regclass);


--
-- Name: core_question id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_question ALTER COLUMN id SET DEFAULT nextval('public.core_question_id_seq'::regclass);


--
-- Name: core_survey id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_survey ALTER COLUMN id SET DEFAULT nextval('public.core_survey_id_seq'::regclass);


--
-- Name: core_surveycorrection id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_surveycorrection ALTER COLUMN id SET DEFAULT nextval('public.core_surveycorrection_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- Name: user_mgmt_department id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_department ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_department_id_seq'::regclass);


--
-- Name: user_mgmt_district id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_district ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_district_id_seq'::regclass);


--
-- Name: user_mgmt_level id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_level ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_level_id_seq'::regclass);


--
-- Name: user_mgmt_leveltype id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_leveltype ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_leveltype_id_seq'::regclass);


--
-- Name: user_mgmt_menu id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menu ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_menu_id_seq'::regclass);


--
-- Name: user_mgmt_menupermission id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menupermission ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_menupermission_id_seq'::regclass);


--
-- Name: user_mgmt_role id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_role_id_seq'::regclass);


--
-- Name: user_mgmt_role_menus id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role_menus ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_role_menus_id_seq'::regclass);


--
-- Name: user_mgmt_user id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_user_id_seq'::regclass);


--
-- Name: user_mgmt_user_groups id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_groups ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_user_groups_id_seq'::regclass);


--
-- Name: user_mgmt_user_roles id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_user_roles_id_seq'::regclass);


--
-- Name: user_mgmt_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_user_user_permissions_id_seq'::regclass);


--
-- Name: user_mgmt_userpost id; Type: DEFAULT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_userpost ALTER COLUMN id SET DEFAULT nextval('public.user_mgmt_userpost_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add session	5	add_session
18	Can change session	5	change_session
19	Can delete session	5	delete_session
20	Can view session	5	view_session
21	Can add site	6	add_site
22	Can change site	6	change_site
23	Can delete site	6	delete_site
24	Can view site	6	view_site
25	Can add menu	7	add_menu
26	Can change menu	7	change_menu
27	Can delete menu	7	delete_menu
28	Can view menu	7	view_menu
29	Can add Role	8	add_role
30	Can change Role	8	change_role
31	Can delete Role	8	delete_role
32	Can view Role	8	view_role
33	Can add menu permission	9	add_menupermission
34	Can change menu permission	9	change_menupermission
35	Can delete menu permission	9	delete_menupermission
36	Can view menu permission	9	view_menupermission
37	Can add user	10	add_user
38	Can change user	10	change_user
39	Can delete user	10	delete_user
40	Can view user	10	view_user
41	Can add level	11	add_level
42	Can change level	11	change_level
43	Can delete level	11	delete_level
44	Can view level	11	view_level
45	Can add department	12	add_department
46	Can change department	12	change_department
47	Can delete department	12	delete_department
48	Can view department	12	view_department
49	Can add level type	13	add_leveltype
50	Can change level type	13	change_leveltype
51	Can delete level type	13	delete_leveltype
52	Can view level type	13	view_leveltype
53	Can add user post	14	add_userpost
54	Can change user post	14	change_userpost
55	Can delete user post	14	delete_userpost
56	Can view user post	14	view_userpost
57	Can add district	15	add_district
58	Can change district	15	change_district
59	Can delete district	15	delete_district
60	Can view district	15	view_district
61	Can add answer	16	add_answer
62	Can change answer	16	change_answer
63	Can delete answer	16	delete_answer
64	Can view answer	16	view_answer
65	Can add central body	17	add_centralbody
66	Can change central body	17	change_centralbody
67	Can delete central body	17	delete_centralbody
68	Can view central body	17	view_centralbody
69	Can add fiscal year	18	add_fiscalyear
70	Can change fiscal year	18	change_fiscalyear
71	Can delete fiscal year	18	delete_fiscalyear
72	Can view fiscal year	18	view_fiscalyear
73	Can add survey	19	add_survey
74	Can change survey	19	change_survey
75	Can delete survey	19	delete_survey
76	Can view survey	19	view_survey
77	Can add question	20	add_question
78	Can change question	20	change_question
79	Can delete question	20	delete_question
80	Can view question	20	view_question
81	Can add province body	21	add_provincebody
82	Can change province body	21	change_provincebody
83	Can delete province body	21	delete_provincebody
84	Can view province body	21	view_provincebody
85	Can add option	22	add_option
86	Can change option	22	change_option
87	Can delete option	22	delete_option
88	Can view option	22	view_option
89	Can add local body	23	add_localbody
90	Can change local body	23	change_localbody
91	Can delete local body	23	delete_localbody
92	Can view local body	23	view_localbody
93	Can add fill survey	24	add_fillsurvey
94	Can change fill survey	24	change_fillsurvey
95	Can delete fill survey	24	delete_fillsurvey
96	Can view fill survey	24	view_fillsurvey
97	Can add answer document	25	add_answerdocument
98	Can change answer document	25	change_answerdocument
99	Can delete answer document	25	delete_answerdocument
100	Can view answer document	25	view_answerdocument
101	Can add survey correction	26	add_surveycorrection
102	Can change survey correction	26	change_surveycorrection
103	Can delete survey correction	26	delete_surveycorrection
104	Can view survey correction	26	view_surveycorrection
105	Can add correction activity log	27	add_correctionactivitylog
106	Can change correction activity log	27	change_correctionactivitylog
107	Can delete correction activity log	27	delete_correctionactivitylog
108	Can view correction activity log	27	view_correctionactivitylog
109	Can add complaint	28	add_complaint
110	Can change complaint	28	change_complaint
111	Can delete complaint	28	delete_complaint
112	Can view complaint	28	view_complaint
113	Can add notification	29	add_notification
114	Can change notification	29	change_notification
115	Can delete notification	29	delete_notification
116	Can view notification	29	view_notification
117	Can add appraisal review request	30	add_appraisalreviewrequest
118	Can change appraisal review request	30	change_appraisalreviewrequest
119	Can delete appraisal review request	30	delete_appraisalreviewrequest
120	Can view appraisal review request	30	view_appraisalreviewrequest
121	Can add access attempt	31	add_accessattempt
122	Can change access attempt	31	change_accessattempt
123	Can delete access attempt	31	delete_accessattempt
124	Can view access attempt	31	view_accessattempt
125	Can add access log	32	add_accesslog
126	Can change access log	32	change_accesslog
127	Can delete access log	32	delete_accesslog
128	Can view access log	32	view_accesslog
\.


--
-- Data for Name: axes_accessattempt; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.axes_accessattempt (id, user_agent, ip_address, username, http_accept, path_info, attempt_time, get_data, post_data, failures_since_start) FROM stdin;
35	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.5	admin	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-28 08:57:20.333369+00	next=/\n---------\nnext=/	csrfmiddlewaretoken=CvS3kfxhkdEOau7gadxBab2gQCHlC7fIGrXGrPmbda12HwLUz2uho5dPG7UH0XrR\nusername=admin\npassword=********************\n---------\ncsrfmiddlewaretoken=hjrdWCgZzoxcMKhWXgWNoqtSiVL9d7XPlfwQ3c5TslUqjMVAm5TtCkEr8qYvBX9Y\nusername=admin\npassword=********************	2
\.


--
-- Data for Name: axes_accesslog; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.axes_accesslog (id, user_agent, ip_address, username, http_accept, path_info, attempt_time, logout_time) FROM stdin;
1	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.192.4	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2021-12-30 06:02:06.982502+00	2022-01-04 11:57:23.933392+00
2	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36	192.168.192.4	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2021-12-30 06:03:05.158851+00	2022-01-04 11:57:23.933392+00
3	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36	192.168.192.4	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2021-12-30 06:04:31.803153+00	2022-01-04 11:57:23.933392+00
4	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	192.168.192.4	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-01-04 11:57:08.920023+00	2022-01-04 11:57:23.933392+00
5	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	192.168.192.4	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-01-05 04:59:58.634309+00	2022-01-05 05:00:03.941464+00
6	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.18.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-01-07 10:38:00.599608+00	2022-01-07 10:38:17.571573+00
7	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36	172.18.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-01-11 09:15:53.61674+00	2022-01-11 09:16:03.20391+00
8	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	172.18.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-01-28 04:03:36.551345+00	2022-02-21 10:00:16.674412+00
9	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-02-21 09:59:51.665764+00	2022-02-21 10:00:16.674412+00
10	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-03-23 10:10:43.184616+00	2022-03-23 10:26:21.335688+00
11	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/admin/login/	2022-03-24 08:15:34.840238+00	2022-04-08 05:36:44.556572+00
12	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/admin/login/	2022-03-24 08:15:40.792253+00	2022-04-08 05:36:44.556572+00
13	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-06 08:31:19.213252+00	2022-04-08 05:36:44.556572+00
14	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-06 08:31:45.265579+00	2022-04-08 05:36:44.556572+00
15	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-06 09:22:17.89048+00	2022-04-08 05:36:44.556572+00
16	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-04-06 09:41:46.857116+00	2022-04-08 05:36:44.556572+00
18	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	tourism_bagmati@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-07 04:55:16.890429+00	\N
19	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	tourism_bagmati@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/users/set-password/	2022-04-07 04:56:27.847902+00	\N
20	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	aanapurna55@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-07 09:50:20.741679+00	\N
21	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	aanapurna55@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/users/set-password/	2022-04-07 09:50:30.801072+00	\N
17	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-07 04:27:40.493418+00	2022-04-08 05:36:44.556572+00
24	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	bagmati_arthik9@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-08 06:02:17.808612+00	\N
25	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	bagmati_arthik9@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/users/set-password/	2022-04-08 06:03:51.855566+00	\N
29	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	sharmabharatkumar11@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-13 04:13:04.794102+00	\N
23	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-08 05:41:47.164872+00	2022-04-26 04:28:48.1564+00
26	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-04-08 10:05:31.062219+00	2022-04-26 04:28:48.1564+00
30	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-04-26 04:28:19.486552+00	2022-04-26 04:28:48.1564+00
31	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-05-06 05:05:34.561903+00	2022-05-06 05:09:19.858665+00
32	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 14:56:47.089651+00	2022-05-29 15:07:48.632297+00
33	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 15:44:44.270831+00	2022-05-29 15:45:23.10103+00
34	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 15:47:39.728104+00	2022-05-29 15:50:22.058274+00
35	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 15:51:39.657331+00	2022-05-29 15:55:39.886222+00
36	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 15:57:31.358711+00	2022-05-29 16:31:19.271943+00
37	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 16:32:15.886351+00	2022-05-29 16:33:49.183839+00
38	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-29 16:34:49.104573+00	2022-05-29 16:40:35.902426+00
39	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 04:50:33.412898+00	2022-05-30 05:03:49.937697+00
40	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 05:04:53.661227+00	2022-05-30 05:05:31.76605+00
41	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 05:06:55.504444+00	2022-05-30 05:10:29.301319+00
27	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-12 03:47:17.714881+00	2022-05-31 09:47:08.178474+00
22	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	bitta_ayog_pradesh2@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-04-08 03:56:53.315657+00	2022-06-03 10:42:41.957241+00
42	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 05:10:43.200398+00	2022-05-30 05:18:18.075675+00
44	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 05:21:22.678936+00	2022-05-30 05:34:03.219667+00
43	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	bagmati_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 05:19:39.632511+00	2022-05-30 06:42:35.119379+00
45	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 05:34:19.386679+00	2022-05-30 06:54:29.787032+00
46	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-05-30 05:43:37.531894+00	2022-05-30 06:54:29.787032+00
47	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 06:43:33.350967+00	2022-05-30 06:54:29.787032+00
48	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 06:57:18.23084+00	2022-05-30 06:59:46.6416+00
50	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-05-30 09:08:07.929797+00	2022-05-30 09:08:52.014961+00
49	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 07:02:37.069744+00	2022-05-30 09:16:23.322266+00
51	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-05-30 09:09:04.996308+00	2022-05-30 09:16:23.322266+00
52	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-05-30 09:16:55.078779+00	2022-05-30 11:46:37.633634+00
53	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 11:34:08.018169+00	2022-05-30 11:46:37.633634+00
55	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 11:46:49.348027+00	2022-05-31 08:31:16.560538+00
28	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/users/set-password/	2022-04-12 03:47:29.311009+00	2022-05-31 09:47:08.178474+00
56	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-31 08:32:02.404973+00	2022-05-31 09:47:08.178474+00
54	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-30 11:35:03.509781+00	2022-06-01 08:45:24.190353+00
57	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-05-31 08:33:35.65655+00	2022-06-01 08:45:24.190353+00
58	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/admin/login/	2022-05-31 09:47:26.008013+00	2022-06-01 08:45:24.190353+00
60	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 09:01:44.546472+00	2022-06-01 15:51:36.048097+00
59	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 08:46:55.589564+00	2022-06-01 15:54:02.440612+00
61	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 15:49:11.493869+00	2022-06-01 15:54:02.440612+00
63	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 15:57:52.413152+00	2022-06-01 15:59:34.366699+00
64	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 15:59:42.855071+00	2022-06-01 16:00:15.275937+00
65	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 16:00:37.8054+00	2022-06-01 16:00:55.453295+00
62	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	bagmati_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 15:54:36.593631+00	2022-06-01 16:01:45.51111+00
66	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 16:01:53.21024+00	2022-06-01 16:03:14.208511+00
67	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-01 16:03:47.324677+00	2022-06-02 06:07:15.310858+00
68	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 06:05:57.348248+00	2022-06-02 06:07:15.310858+00
69	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	bagmati_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 06:07:32.68847+00	2022-06-02 06:30:01.752062+00
70	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 06:10:52.673431+00	2022-06-02 09:23:33.518289+00
71	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 09:16:27.500782+00	2022-06-02 09:23:33.518289+00
72	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	bagmati_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 09:17:06.437234+00	2022-06-02 09:24:57.627393+00
73	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 09:23:40.02339+00	2022-06-02 09:40:00.394437+00
74	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 09:25:08.744495+00	2022-06-02 09:43:18.561385+00
75	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-06-02 09:43:02.369966+00	2022-06-02 09:43:18.561385+00
76	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	bitta_ayog_pradesh2@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-06-03 10:25:02.665244+00	2022-06-03 10:42:41.957241+00
79	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	bagmati_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-07-06 11:54:41.500437+00	\N
77	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-07-05 06:35:06.990461+00	2022-07-06 12:00:00.404391+00
78	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-07-06 11:46:22.510749+00	2022-07-06 12:00:00.404391+00
80	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik1@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/dashboard/users/login/	2022-07-06 12:01:48.831218+00	\N
81	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36	192.168.208.6	province2_arthik1@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3	/users/set-password/	2022-07-06 12:02:04.368409+00	\N
82	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	192.168.208.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-07-08 06:06:31.530562+00	2022-07-13 08:42:07.173003+00
83	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-13 08:42:04.883855+00	2022-07-13 08:42:07.173003+00
84	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 04:57:36.382041+00	2022-07-19 05:03:45.106347+00
85	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 05:03:52.164008+00	2022-07-19 05:44:21.039226+00
89	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 08:02:26.936658+00	2022-07-19 08:56:06.395442+00
86	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 05:05:08.488442+00	2022-07-19 09:04:35.199118+00
87	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 05:44:29.767941+00	2022-07-19 09:04:35.199118+00
88	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 06:02:14.176011+00	2022-07-19 09:04:35.199118+00
90	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/admin/login/	2022-07-19 08:56:19.617507+00	2022-07-19 09:04:35.199118+00
91	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 09:04:41.697853+00	2022-07-19 10:10:04.092819+00
92	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin_madesh@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 10:09:24.695491+00	2022-07-19 10:10:04.092819+00
93	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 10:10:16.264521+00	2022-07-25 04:57:21.918234+00
94	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-19 10:11:26.286139+00	2022-07-25 04:57:21.918234+00
96	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	lumbini_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-25 05:00:48.901134+00	\N
95	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-25 04:57:27.680912+00	2022-10-20 09:41:10.236306+00
97	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	172.24.0.6	lumbini_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-07-25 05:02:13.202906+00	\N
98	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	172.24.0.6	lumbini_arthik@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-07-25 05:04:45.772388+00	\N
99	Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-07-25 05:05:49.010486+00	2022-10-20 09:41:10.236306+00
100	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2022-07-29 10:10:05.084398+00	2022-10-20 09:41:10.236306+00
101	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-10-20 09:36:56.020937+00	2022-10-20 09:41:10.236306+00
103	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	172.24.0.6	anu@yopmail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-10-20 10:01:52.760893+00	\N
102	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0	172.24.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8	/dashboard/users/login/	2022-10-20 09:45:29.853742+00	2023-03-08 05:06:47.511414+00
104	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-03-08 05:06:30.694124+00	2023-03-08 05:06:47.511414+00
105	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-03-08 05:50:16.767763+00	2023-03-08 05:51:45.214711+00
106	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-03-08 08:10:27.011204+00	2023-03-08 08:28:49.98739+00
107	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-03-09 04:12:41.007744+00	2023-03-09 04:12:45.11517+00
108	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8	/dashboard/users/login/	2023-03-09 04:36:42.172471+00	2023-03-09 05:06:23.020324+00
109	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8	/dashboard/users/login/	2023-03-09 05:08:30.567652+00	2023-03-09 05:09:14.7083+00
110	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8	/dashboard/users/login/	2023-03-09 05:09:31.846292+00	2023-03-10 03:56:00.978309+00
111	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9	/dashboard/users/login/	2023-03-09 05:49:43.833919+00	2023-03-10 03:56:00.978309+00
112	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8	/dashboard/users/login/	2023-03-10 03:56:04.840531+00	2023-03-16 05:10:47.883007+00
113	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36	172.20.0.6	admin@mail.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8	/dashboard/users/login/	2023-03-16 05:11:01.710517+00	2023-03-16 05:11:16.147095+00
114	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.5	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-19 10:24:13.407412+00	2023-06-19 10:24:22.212259+00
115	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.5	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-19 10:24:32.011998+00	2023-06-19 10:24:34.675289+00
116	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.5	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-19 10:25:15.469+00	2023-06-19 10:59:12.821738+00
117	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.5	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-19 11:21:04.918267+00	2023-06-26 05:43:25.155963+00
118	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.5	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-26 05:43:22.685184+00	2023-06-26 05:43:25.155963+00
119	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.6	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-28 09:00:06.17127+00	2023-06-28 09:00:59.199683+00
120	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36	172.20.0.6	admin@admin.com	text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7	/dashboard/users/login/	2023-06-28 09:01:01.734344+00	2023-06-28 09:01:03.212934+00
\.


--
-- Data for Name: core_answer; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_answer (id, created_at, updated_at, month, value, fill_survey_id, option_id, created_by_id, created_by_level_id, fiscal_year_id) FROM stdin;
486	2022-06-01 15:55:28.348768+00	2022-06-01 15:55:28.348792+00	\N	invoice-logo.png	8	8	\N	3	\N
487	2022-06-01 15:55:28.353201+00	2022-06-01 15:55:28.353221+00	\N	90	8	6	14	3	\N
488	2022-06-01 15:55:28.355577+00	2022-06-01 15:55:28.355594+00	\N	40	8	7	14	3	\N
489	2022-06-02 06:29:42.851363+00	2022-06-02 06:29:42.851459+00	\N	invoice_ORD000001.pdf	8	16	\N	3	\N
490	2022-06-02 06:29:42.856929+00	2022-06-02 06:29:42.856952+00	\N	invoice_ORD000001.pdf	8	32	\N	3	\N
491	2022-06-02 06:29:42.861185+00	2022-06-02 06:29:42.861206+00	\N	90	8	13	14	3	\N
492	2022-06-02 06:29:42.864318+00	2022-06-02 06:29:42.864339+00	\N	80	8	14	14	3	\N
493	2022-06-02 06:29:42.867109+00	2022-06-02 06:29:42.867129+00	\N	89	8	15	14	3	\N
494	2022-06-02 06:29:42.869992+00	2022-06-02 06:29:42.870012+00	\N		8	29	14	3	\N
495	2022-06-02 06:29:42.872883+00	2022-06-02 06:29:42.872903+00	\N		8	30	14	3	\N
496	2022-06-02 06:29:42.875757+00	2022-06-02 06:29:42.875777+00	\N	89	8	31	14	3	\N
497	2022-06-02 09:18:44.671084+00	2022-06-02 09:18:44.671109+00	5	invoice-logo.png	8	12	\N	3	\N
498	2022-06-02 09:18:44.678905+00	2022-06-02 09:18:44.678928+00	5	90	8	9	14	3	\N
499	2022-06-02 09:18:44.681825+00	2022-06-02 09:18:44.681848+00	5	90	8	10	14	3	\N
500	2022-06-02 09:18:44.684772+00	2022-06-02 09:18:44.684793+00	5	100	8	129	14	3	\N
501	2022-06-02 09:18:44.68762+00	2022-06-02 09:18:44.687641+00	5	2079-02-19	8	11	14	3	\N
502	2022-06-03 10:29:57.496735+00	2022-06-03 10:29:57.496762+00	4	Get_Started_With_Smallpdf.pdf	7	12	\N	2	\N
503	2022-06-03 10:29:57.502269+00	2022-06-03 10:29:57.502291+00	4	22	7	9	19	2	\N
504	2022-06-03 10:29:57.505209+00	2022-06-03 10:29:57.505259+00	4	34	7	10	19	2	\N
505	2022-06-03 10:29:57.508213+00	2022-06-03 10:29:57.508234+00	4	155	7	129	19	2	\N
506	2022-06-03 10:29:57.511028+00	2022-06-03 10:29:57.511049+00	4	2022/12/12	7	11	19	2	\N
507	2022-06-03 10:33:02.003869+00	2022-06-03 10:33:02.003902+00	9	Get_Started_With_Smallpdf.pdf	7	12	\N	2	\N
508	2022-06-03 10:33:02.009375+00	2022-06-03 10:33:02.009399+00	9	45	7	9	19	2	\N
509	2022-06-03 10:33:02.012252+00	2022-06-03 10:33:02.012276+00	9	24	7	10	19	2	\N
510	2022-06-03 10:33:02.015164+00	2022-06-03 10:33:02.015184+00	9	53	7	129	19	2	\N
511	2022-06-03 10:33:02.017982+00	2022-06-03 10:33:02.018002+00	9	2079-02-03	7	11	19	2	\N
512	2022-07-06 11:55:36.430146+00	2022-07-06 11:55:36.430173+00	\N	Get_Started_With_Smallpdf.pdf	8	20	\N	3	\N
513	2022-07-06 11:55:36.451766+00	2022-07-06 11:55:36.451791+00	\N	Get_Started_With_Smallpdf.pdf	8	24	\N	3	\N
514	2022-07-06 11:55:36.457441+00	2022-07-06 11:55:36.45746+00	\N	8990	8	17	14	3	\N
515	2022-07-06 11:55:36.460092+00	2022-07-06 11:55:36.460111+00	\N	2931	8	18	14	3	\N
516	2022-07-06 11:55:36.4626+00	2022-07-06 11:55:36.462618+00	\N	33	8	19	14	3	\N
517	2022-07-06 11:55:36.46507+00	2022-07-06 11:55:36.465087+00	\N	8374	8	21	14	3	\N
518	2022-07-06 11:55:36.467559+00	2022-07-06 11:55:36.467576+00	\N	8492	8	22	14	3	\N
519	2022-07-06 11:55:36.470204+00	2022-07-06 11:55:36.470221+00	\N	33	8	23	14	3	\N
521	2022-07-25 05:05:10.244475+00	2022-07-25 05:08:55.801213+00	\N	122366	9	6	15	5	\N
522	2022-07-25 05:05:10.246833+00	2022-07-25 05:08:55.80845+00	\N	123466	9	7	15	5	\N
520	2022-07-25 05:05:10.238251+00	2022-07-25 05:08:55.81552+00	\N	Screenshot_2022-07-07_17-18-20.png	9	8	\N	5	\N
524	2022-10-20 10:03:23.353156+00	2022-10-20 10:06:16.936012+00	\N	90000	5	6	43	4	\N
525	2022-10-20 10:03:23.355895+00	2022-10-20 10:06:16.944534+00	\N	100000	5	7	43	4	\N
523	2022-10-20 10:03:23.346014+00	2022-10-20 10:06:16.952367+00	\N	Get_Started_With_Smallpdf_1Rw6IuV.pdf	5	8	\N	4	\N
526	2022-10-20 10:10:10.639523+00	2022-10-20 10:10:10.639556+00	4	Get_Started_With_Smallpdf.pdf	5	12	\N	4	\N
527	2022-10-20 10:10:10.644676+00	2022-10-20 10:10:10.644703+00	4	80000	5	9	43	4	\N
528	2022-10-20 10:10:10.647282+00	2022-10-20 10:10:10.647305+00	4	20000	5	10	43	4	\N
529	2022-10-20 10:10:10.649875+00	2022-10-20 10:10:10.649893+00	4	25	5	129	43	4	\N
530	2022-10-20 10:10:10.652392+00	2022-10-20 10:10:10.652412+00	4	2079-07-09	5	11	43	4	\N
531	2022-10-20 10:20:35.247925+00	2022-10-20 10:20:35.247948+00	\N	Get_Started_With_Smallpdf.pdf	5	163	\N	4	\N
532	2022-10-20 10:20:35.2524+00	2022-10-20 10:20:35.25242+00	\N	name, char field	5	158	43	4	\N
533	2022-10-20 10:20:35.254868+00	2022-10-20 10:20:35.254887+00	\N	89	5	162	43	4	\N
534	2022-10-20 10:20:35.257392+00	2022-10-20 10:20:35.257411+00	\N	800	5	160	43	4	\N
535	2022-10-20 10:20:35.259871+00	2022-10-20 10:20:35.259901+00	\N	900	5	161	43	4	\N
536	2022-10-20 10:20:35.26236+00	2022-10-20 10:20:35.262377+00	\N	True	5	159	43	4	\N
537	2022-10-20 10:20:35.266598+00	2022-10-20 10:20:35.26662+00	\N		5	157	43	4	2
538	2022-10-20 10:20:35.270961+00	2022-10-20 10:20:35.27098+00	\N		5	157	43	4	3
539	2022-10-20 10:20:35.274586+00	2022-10-20 10:20:35.274605+00	\N		5	157	43	4	1
540	2023-03-10 03:53:14.422209+00	2023-03-10 03:53:14.422237+00	\N	sample_document.pdf	16	52	\N	8	\N
541	2023-03-10 03:53:14.433177+00	2023-03-10 03:53:14.433207+00	\N	True	16	50	1	8	\N
542	2023-03-10 03:53:14.436614+00	2023-03-10 03:53:14.436639+00	\N	False	16	51	1	8	\N
543	2023-03-10 03:55:30.798431+00	2023-03-10 03:55:30.798457+00	\N	sample_document.pdf	16	55	\N	8	\N
544	2023-03-10 03:55:30.803469+00	2023-03-10 03:55:30.803492+00	\N	True	16	53	1	8	\N
545	2023-03-10 03:55:30.806194+00	2023-03-10 03:55:30.806222+00	\N	False	16	54	1	8	\N
\.


--
-- Data for Name: core_answerdocument; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_answerdocument (id, created_at, updated_at, document, answer_id) FROM stdin;
108	2022-06-01 15:55:28.349944+00	2022-06-01 15:55:28.349963+00	answer-documents/invoice-logo.png	486
109	2022-06-02 06:29:42.852742+00	2022-06-02 06:29:42.852767+00	answer-documents/invoice_ORD000001.pdf	489
110	2022-06-02 06:29:42.857729+00	2022-06-02 06:29:42.85775+00	answer-documents/invoice_ORD000001_ctlIkbj.pdf	490
111	2022-06-02 09:18:44.672226+00	2022-06-02 09:18:44.672247+00	answer-documents/invoice-logo_goE65Rq.png	497
112	2022-06-03 10:29:57.498217+00	2022-06-03 10:29:57.49824+00	answer-documents/Get_Started_With_Smallpdf_rTzy5oc.pdf	502
113	2022-06-03 10:33:02.005312+00	2022-06-03 10:33:02.005336+00	answer-documents/Get_Started_With_Smallpdf_KOhheGy.pdf	507
114	2022-07-06 11:55:36.431284+00	2022-07-06 11:55:36.431313+00	answer-documents/Get_Started_With_Smallpdf_JPVzUKF.pdf	512
115	2022-07-06 11:55:36.452591+00	2022-07-06 11:55:36.45261+00	answer-documents/Get_Started_With_Smallpdf_4y8XMN6.pdf	513
116	2022-07-25 05:05:10.239943+00	2022-07-25 05:05:10.239963+00	Screenshot_2022-07-07_17-18-20.png	520
117	2022-10-20 10:03:23.348027+00	2022-10-20 10:03:23.348049+00	answer-documents/Get_Started_With_Smallpdf_1Rw6IuV.pdf	523
118	2022-10-20 10:10:10.640951+00	2022-10-20 10:10:10.640978+00	answer-documents/Get_Started_With_Smallpdf_tLjLSW4.pdf	526
119	2022-10-20 10:20:35.249057+00	2022-10-20 10:20:35.249078+00	answer-documents/Get_Started_With_Smallpdf_PpG4r3C.pdf	531
120	2023-03-10 03:53:14.42477+00	2023-03-10 03:53:14.424799+00	answer-documents/sample_document.pdf	540
121	2023-03-10 03:55:30.799648+00	2023-03-10 03:55:30.799676+00	answer-documents/sample_document_VfPFDMe.pdf	543
\.


--
-- Data for Name: core_appraisalreviewrequest; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_appraisalreviewrequest (id, created_at, updated_at, subject, score_obtained, reason, expected_score, file_upload, question_id_id, is_checked, level_id, user_id) FROM stdin;
12	2022-10-20 10:15:05.020412+00	2022-10-20 10:15:05.020439+00	Unhappy with eval	60	reason	80	appraisal_review_request/Get_Started_With_Smallpdf_KMykiPu.pdf	4	t	4	43
\.


--
-- Data for Name: core_centralbody; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_centralbody (id, created_at, updated_at, name, name_np) FROM stdin;
\.


--
-- Data for Name: core_complaint; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_complaint (id, created_at, updated_at, sub, msg, is_checked, level_id, user_id, complaint_file) FROM stdin;
6	2022-10-20 10:12:42.06977+00	2022-10-20 10:12:42.069794+00	feature issue	feature issue desc	t	4	43	complaint-files/Get_Started_With_Smallpdf_evHBn9N.pdf
\.


--
-- Data for Name: core_correctionactivitylog; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_correctionactivitylog (id, created_at, updated_at, user_name, user_email, user_level, action_level, action_level_type, option, old_value, changed_value, activity, option_id, question_id, question_title) FROM stdin;
11	2022-07-25 05:08:55.799691+00	2022-07-25 05:08:55.799713+00	admin admin	admin@mail.com	Local Level 1	प्रदेश सरकार, गण्डकी प्रदेश	P	क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम	1223	122366	सुधार अनुमति सूचक चेक गरियो।	6	2	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः
16	2022-10-20 10:06:16.951644+00	2022-10-20 10:06:16.951676+00	admin admin	admin@mail.com	Local Level 1	प्रदेश सरकार, गण्डकी प्रदेश	P	ग. अपलोड फिल्ड	Get_Started_With_Smallpdf.pdf	Get_Started_With_Smallpdf_1Rw6IuV.pdf	सुधार अनुमति सूचक चेक गरियो।	8	2	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः
12	2022-07-25 05:08:55.807721+00	2022-07-25 05:08:55.807747+00	admin admin	admin@mail.com	Local Level 1	प्रदेश सरकार, गण्डकी प्रदेश	P	ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम	1234	123466	सुधार अनुमति सूचक चेक गरियो।	7	2	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः
13	2022-07-25 05:08:55.8149+00	2022-07-25 05:08:55.81492+00	admin admin	admin@mail.com	Local Level 1	प्रदेश सरकार, गण्डकी प्रदेश	P	ग. अपलोड फिल्ड	Feedbacks on IIS 2078-05-16.pdf	Feedbacks_on_IIS_2078-05-16.pdf	सुधार अनुमति सूचक चेक गरियो।	8	2	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः
14	2022-10-20 10:06:16.933725+00	2022-10-20 10:06:16.933758+00	admin admin	admin@mail.com	Local Level 1	प्रदेश सरकार, गण्डकी प्रदेश	P	क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम	9000	90000	सुधार अनुमति सूचक चेक गरियो।	6	2	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः
15	2022-10-20 10:06:16.943747+00	2022-10-20 10:06:16.943771+00	admin admin	admin@mail.com	Local Level 1	प्रदेश सरकार, गण्डकी प्रदेश	P	ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम	10000	100000	सुधार अनुमति सूचक चेक गरियो।	7	2	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः
\.


--
-- Data for Name: core_fillsurvey; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_fillsurvey (id, created_at, updated_at, budget_period, approval_state, created_by_id, survey_id, level_id_id) FROM stdin;
2	2021-11-15 17:41:53.184269+00	2021-11-15 17:41:53.184291+00	\N	\N	\N	1	6
4	2021-11-15 18:06:33.274285+00	2021-11-15 18:06:33.27434+00	\N	\N	\N	2	13
5	2021-11-15 18:10:58.539085+00	2021-11-15 18:10:58.539112+00	\N	\N	\N	1	4
6	2021-11-15 18:11:19.958571+00	2021-11-15 18:11:19.958601+00	\N	\N	\N	2	17
7	2021-11-15 18:21:51.557953+00	2021-11-15 18:21:51.557974+00	\N	\N	\N	1	2
8	2021-11-15 18:39:29.49639+00	2021-11-15 18:39:29.496412+00	\N	\N	\N	1	3
9	2021-11-15 18:48:06.643528+00	2021-11-15 18:48:06.643554+00	\N	\N	\N	1	5
10	2021-11-15 18:57:42.167143+00	2021-11-15 18:57:42.167169+00	\N	\N	\N	1	1
12	2021-11-16 06:03:08.034397+00	2021-11-16 06:03:08.034417+00	\N	\N	\N	1	7
14	2021-11-25 04:10:31.20401+00	2021-11-25 04:10:31.204029+00	\N	\N	\N	2	16
15	2022-04-07 09:59:38.473039+00	2022-04-07 09:59:38.473065+00	\N	\N	\N	2	431
16	2022-04-08 03:44:35.699295+00	2022-04-08 03:44:35.699316+00	\N	\N	\N	2	8
\.


--
-- Data for Name: core_fiscalyear; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_fiscalyear (id, created_at, updated_at, name, start_date, end_date, end_date_bs, start_date_bs, active_fy) FROM stdin;
2	2021-11-15 13:13:15.704504+00	2021-11-15 13:13:15.704526+00	२०७७/७८	2020-06-01	2021-06-01	\N	\N	f
3	2021-11-15 13:14:46.166704+00	2021-11-15 13:14:46.166732+00	२०७९/८०	2022-06-01	2023-06-01	\N	\N	f
1	2021-11-15 13:12:10.827796+00	2021-11-19 09:36:47.568155+00	२०७८/७९	2021-06-01	2022-06-30	2078-08-09	2078-08-01	f
\.


--
-- Data for Name: core_localbody; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_localbody (id, created_at, updated_at, name, name_np, province_id) FROM stdin;
\.


--
-- Data for Name: core_notification; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_notification (id, created_at, updated_at, msg, is_viewed, correction_id, user_id, level_id, question_id, correction_checked) FROM stdin;
103	2021-12-12 07:42:04.605149+00	2021-12-12 07:42:04.605171+00	नयाँ सूचक प्रदेश सरकार, २ नं. प्रदेश को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	f	\N	17	2	12	f
1	2021-11-15 17:39:33.749061+00	2021-11-15 18:19:12.393453+00	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	t	\N	13	13	23	f
109	2022-06-01 15:56:08.802066+00	2022-06-01 15:56:08.80209+00	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा पठाइएको छ।	f	11	14	3	\N	f
110	2022-06-02 09:17:45.153969+00	2022-06-02 09:17:45.153995+00	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा पठाइएको छ।	f	12	14	3	\N	f
111	2022-06-02 09:17:45.17734+00	2022-06-02 09:17:45.177363+00	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा पठाइएको छ।	f	13	14	3	\N	f
112	2022-07-25 05:07:16.90792+00	2022-07-25 05:07:16.907942+00	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा पठाइएको छ।	f	14	15	5	\N	f
113	2022-07-25 05:08:55.822684+00	2022-07-25 05:08:55.822702+00	तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।	f	14	15	5	\N	t
115	2022-10-20 10:06:16.959672+00	2022-10-20 10:06:16.959696+00	तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।	f	15	43	4	\N	t
114	2022-10-20 10:05:38.43623+00	2022-10-20 10:05:38.436254+00	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता anu@yopmail.com द्वारा पठाइएको छ।	t	15	43	4	\N	f
\.


--
-- Data for Name: core_option; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_option (id, created_at, updated_at, title, field_type, is_calc_field, created_by_id, question_id, option_type, sequence_id) FROM stdin;
17	2021-11-15 13:34:19.371026+00	2021-11-15 13:48:47.043239+00	क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य	De	f	\N	7	Deno	1
1	2021-11-15 13:21:34.579492+00	2021-11-15 13:26:09.376664+00	क. लेखा परिक्षण भएको आर्थिक वर्ष	FY	f	\N	1	\N	1
2	2021-11-15 13:21:34.579545+00	2021-11-15 13:26:13.194091+00	ख. कुल लेखा परिक्षण गरिएको रकम	De	f	\N	1	Deno	2
3	2021-11-15 13:21:34.579577+00	2021-11-15 13:26:17.654009+00	ग. कायम भएको बेरुजुको रकम	De	f	\N	1	Num	3
4	2021-11-15 13:21:34.579605+00	2021-11-15 13:26:21.461225+00	घ. बेरुजु प्रतिशत	P	t	\N	1	Per	4
5	2021-11-15 13:21:34.579633+00	2021-11-15 13:26:26.709489+00	ङ. अपलोड फिल्ड	F	f	\N	1	\N	5
6	2021-11-15 13:23:02.34774+00	2021-11-15 13:26:31.775793+00	क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम	De	f	\N	2	\N	1
7	2021-11-15 13:23:02.347809+00	2021-11-15 13:26:35.903148+00	ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम	De	f	\N	2	\N	2
8	2021-11-15 13:23:02.34784+00	2021-11-15 13:26:39.897715+00	ग. अपलोड फिल्ड	F	f	\N	2	\N	3
9	2021-11-15 13:25:25.243426+00	2021-11-15 17:47:47.157522+00	क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम	De	f	\N	3	Deno	1
10	2021-11-15 13:25:25.24348+00	2021-11-15 17:47:47.159025+00	ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम	De	f	\N	3	Num	2
11	2021-11-15 13:25:25.24351+00	2021-11-15 17:47:47.160463+00	ग. जम्मा गरेको मिति	D	f	\N	3	\N	3
13	2021-11-15 13:29:07.802597+00	2021-11-15 13:32:20.63887+00	क. कुल विनियोजित बजेट रकम	De	f	\N	5	Deno	1
14	2021-11-15 13:29:07.80265+00	2021-11-15 13:32:25.246798+00	ख. कुल खर्च भएको बजेट रकम	De	f	\N	5	Num	2
15	2021-11-15 13:29:07.80268+00	2021-11-15 13:32:29.63875+00	ग. खर्च प्रतिशत	P	t	\N	5	Per	3
16	2021-11-15 13:29:07.802708+00	2021-11-15 13:32:32.981535+00	घ. अपलोड फिल्ड	F	f	\N	5	\N	4
28	2021-11-15 13:37:25.937427+00	2021-11-15 13:42:31.642076+00	घ. अपलोड फिल्ड	F	f	\N	9	\N	4
41	2021-11-15 13:55:26.513424+00	2021-11-15 13:55:48.140262+00	ङ. अपलोड फिल्ड	F	f	\N	12	\N	5
27	2021-11-15 13:37:25.937399+00	2021-11-15 13:42:36.05173+00	ग. चैत्र मसान्त भित्र उपलब्ध नगराएको	B	f	\N	9	\N	3
26	2021-11-15 13:37:25.93737+00	2021-11-15 13:42:44.031496+00	ख. उपलब्ध गराएको मितिः	D	f	\N	9	\N	2
25	2021-11-15 13:37:25.937319+00	2021-11-15 13:42:49.430073+00	क. चैत्र मसान्त भित्र उपलब्ध गराएको	B	f	\N	9	\N	1
32	2021-11-15 13:40:43.500202+00	2021-11-15 13:42:12.415206+00	घ. अपलोड फिल्ड	F	f	\N	10	\N	4
31	2021-11-15 13:40:43.500167+00	2021-11-15 13:42:17.314405+00	ग. खर्च प्रतिशत	P	t	\N	10	Per	3
30	2021-11-15 13:40:43.50013+00	2021-11-15 13:42:22.212074+00	ख. कुल पूँजीगत बजेट खर्च रकम	De	f	\N	10	Num	2
29	2021-11-15 13:40:43.500056+00	2021-11-15 13:42:25.659008+00	क. कुल विनियोजित पूँजीतगत बजेट रकम	De	f	\N	10	Deno	1
24	2021-11-15 13:36:13.660328+00	2021-11-15 13:42:53.887888+00	घ. अपलोड फिल्ड	F	f	\N	8	\N	4
23	2021-11-15 13:36:13.660293+00	2021-11-15 13:42:59.294356+00	ग. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकमको तुलनामा गत आर्थिक वर्षको राजस्व सङ्कलन रकममा भएको बृद्धि प्रतिशत	P	t	\N	8	Per	3
22	2021-11-15 13:36:13.660254+00	2021-11-15 13:47:56.066436+00	ख. गत आर्थिक वर्षको राजस्व सङ्कलन रकम	De	f	\N	8	Num	2
21	2021-11-15 13:36:13.660192+00	2021-11-15 13:48:19.613247+00	क. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकम	De	f	\N	8	Deno	1
20	2021-11-15 13:34:19.371163+00	2021-11-15 13:48:32.462334+00	घ. अपलोड फिल्ड	F	f	\N	7	\N	4
19	2021-11-15 13:34:19.371127+00	2021-11-15 13:48:36.719592+00	ग. राजस्व सङ्कलन प्रतिशत	P	t	\N	7	Per	3
18	2021-11-15 13:34:19.371088+00	2021-11-15 13:48:41.531368+00	ख. यथार्थ सङ्कलन भएको राजस्व	De	f	\N	7	Num	2
36	2021-11-15 13:52:37.076598+00	2021-11-15 13:52:51.361082+00	घ. अपलोड फिल्ड	F	f	\N	11	\N	4
35	2021-11-15 13:52:37.076571+00	2021-11-15 13:52:55.985374+00	ग. पुस मसान्तभित्र पेश नगरेको	B	f	\N	11	\N	3
34	2021-11-15 13:52:37.076541+00	2021-11-15 13:53:00.612118+00	ख. पेश गरेको मिति	D	f	\N	11	\N	2
33	2021-11-15 13:52:37.07649+00	2021-11-15 13:53:04.684764+00	क. पुस मसान्तभित्र पेश गरेको	B	f	\N	11	\N	1
40	2021-11-15 13:55:26.51339+00	2021-11-15 13:55:52.350804+00	घ. सार्वजनिक गरेको मिति	D	f	\N	12	\N	4
39	2021-11-15 13:55:26.513356+00	2021-11-15 13:55:56.679135+00	ग. वार्षिक समिक्षा भए समिक्षा गरेको गरेको मिति	D	f	\N	12	\N	3
38	2021-11-15 13:55:26.513318+00	2021-11-15 13:56:02.450564+00	ख. वार्षिक समिक्षा नगरेको	B	f	\N	12	\N	2
37	2021-11-15 13:55:26.513255+00	2021-11-15 13:56:06.652946+00	क. वार्षिक समिक्षा गरेको	B	f	\N	12	\N	1
44	2021-11-15 13:56:46.500809+00	2021-11-15 13:57:10.495299+00	ग. अपलोड फिल्ड	F	f	\N	13	\N	3
43	2021-11-15 13:56:46.500753+00	2021-11-15 13:57:14.191566+00	ख. वायुको गुणस्तरको अवस्था सुधार नभएको	B	f	\N	13	\N	2
42	2021-11-15 13:56:46.500687+00	2021-11-15 13:57:17.820021+00	क. वायुको गुणस्तरको अवस्था सुधार भएको	B	f	\N	13	\N	1
61	2021-11-15 14:10:01.088363+00	2021-11-15 14:10:37.234515+00	ग. जम्मा गरेको मिति।	D	f	\N	20	\N	3
62	2021-11-15 14:10:01.088398+00	2021-11-15 14:10:42.718982+00	घ. अपलोड फिल्ड	F	f	\N	20	\N	4
47	2021-11-15 13:58:03.905542+00	2021-11-15 13:58:57.22432+00	ग. अपलोड फिल्ड	F	f	\N	14	\N	3
46	2021-11-15 13:58:03.905505+00	2021-11-15 13:59:01.617191+00	ख. पछिल्लो आर्थिक वर्ष समुदायमा आधारित वन व्यवस्थापन गरिएको वनको क्षेत्रफल	De	f	\N	14	\N	2
45	2021-11-15 13:58:03.905441+00	2021-11-15 13:59:05.195247+00	क. अघिल्लो आर्थिक वर्षसम्मको समुदायमा आधारित वन व्यवस्थापन गरिएको वनको क्षेत्रफल	De	f	\N	14	\N	1
49	2021-11-15 14:01:36.76024+00	2021-11-15 14:01:57.140098+00	ख. प्रविष्टि नगरेको	B	f	\N	15	\N	2
48	2021-11-15 14:01:36.760175+00	2021-11-15 14:02:02.441603+00	क. प्रविष्टि गरेको	B	f	\N	15	\N	1
50	2021-11-15 14:03:34.837589+00	2021-11-15 14:04:30.330689+00	क. असार १० गते भित्र आय व्ययको अनुमान पेश गरेको	B	f	\N	16	\N	1
51	2021-11-15 14:03:34.837654+00	2021-11-15 14:04:34.52036+00	ख. असार १० गते पछि आय व्ययको अनुमान पेश गरेको	B	f	\N	16	\N	2
52	2021-11-15 14:03:34.837691+00	2021-11-15 14:04:39.308086+00	ग. अपलोड फिल्ड	F	f	\N	16	\N	3
55	2021-11-15 14:04:42.452303+00	2021-11-15 14:04:52.991751+00	ग. अपलोड फिल्ड	F	f	\N	17	\N	3
54	2021-11-15 14:04:42.452267+00	2021-11-15 14:04:56.9378+00	ख. असार १० गते भित्र राजस्व र व्यको अनुमान पेश गरी असार मसान्त भित्र पारित नगरेको	B	f	\N	17	\N	2
53	2021-11-15 14:04:42.452202+00	2021-11-15 14:05:04.459759+00	क. असार १० गते भित्र राजस्व र व्यको अनुमान पेश गरी असार मसान्त भित्र पारित गरेको	B	f	\N	17	\N	1
59	2021-11-15 14:10:01.088261+00	2021-11-15 14:10:27.803638+00	क. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकम	De	f	\N	20	\N	1
60	2021-11-15 14:10:01.088326+00	2021-11-15 14:10:32.870904+00	ख. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकमको ४० प्रतिशतले हुने रकम प्रदेश सञ्चित कोषमा जम्मा गरेको रकम	De	f	\N	20	\N	2
66	2021-11-15 14:11:54.220624+00	2021-11-15 14:12:30.28008+00	घ. अपलोड फिल्ड	F	f	\N	21	\N	4
65	2021-11-15 14:11:54.220589+00	2021-11-15 14:12:35.098979+00	ग. पुस मसान्तभित्र पेश नगरेको	B	f	\N	21	\N	3
64	2021-11-15 14:11:54.220552+00	2021-11-15 14:12:40.050286+00	ख. पेश गरेको मिति	D	f	\N	21	\N	2
63	2021-11-15 14:11:54.220488+00	2021-11-15 14:12:43.684919+00	क. पुस मसान्तभित्र पेश गरेको	B	f	\N	21	\N	1
70	2021-11-15 14:13:41.541173+00	2021-11-15 14:13:49.121997+00	घ. अपलोड फिल्ड	F	f	\N	22	\N	4
69	2021-11-15 14:13:41.541147+00	2021-11-15 14:13:53.689505+00	ग. वार्षिक समिक्षा नगरेको	B	f	\N	22	\N	3
68	2021-11-15 14:13:41.541117+00	2021-11-15 14:13:57.871884+00	ख. समिक्षा सम्बन्धी विवरण सार्वजनिक गरेको मिति	D	f	\N	22	\N	2
67	2021-11-15 14:13:41.541061+00	2021-11-15 14:14:02.453153+00	क. वार्षिक समिक्षा गरेको मिति	D	f	\N	22	\N	1
74	2021-11-15 14:16:30.140162+00	2021-11-15 14:50:52.420043+00	घ. अपलोड फिल्ड	F	f	\N	24	\N	4
71	2021-11-15 14:16:30.14003+00	2021-11-15 14:50:35.558616+00	क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य	De	f	\N	24	Deno	1
72	2021-11-15 14:16:30.140091+00	2021-11-15 14:50:42.831387+00	ख. यथार्थ सङ्कलन भएको राजस्व	De	f	\N	24	Num	2
73	2021-11-15 14:16:30.140127+00	2021-11-15 14:50:47.973312+00	ग. प्रक्षेपित लक्ष्यमा राजस्व सङ्कलन प्रतिशत	P	t	\N	24	Per	3
76	2021-11-15 14:52:36.455145+00	2021-11-15 14:52:52.681098+00	ख. गत आर्थिक वर्षको राजस्व सङ्कलन रकम	De	f	\N	25	Num	2
81	2021-11-15 15:21:44.152485+00	2021-11-15 15:28:41.271524+00	ग. खर्च प्रतिशत	P	t	\N	27	Per	3
78	2021-11-15 14:52:36.455202+00	2021-11-15 14:52:44.748313+00	घ. अपलोड फिल्ड	F	f	\N	25	\N	4
77	2021-11-15 14:52:36.455174+00	2021-11-15 14:52:48.868464+00	ग. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकमको तुलनामा गत आर्थिक वर्षको राजस्व सङ्कलन रकममा भएको बृद्धि प्रतिशत	P	t	\N	25	Per	3
75	2021-11-15 14:52:36.455094+00	2021-11-15 14:52:58.035208+00	क. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकम	De	f	\N	25	Deno	1
79	2021-11-15 15:21:44.15239+00	2021-11-15 15:28:32.534806+00	क. कुल विनियोजित बजेट रकम	De	f	\N	27	Deno	1
80	2021-11-15 15:21:44.152448+00	2021-11-15 15:28:37.822608+00	ख. कुल खर्च भएको बजेट रकम	De	f	\N	27	Num	2
84	2021-11-15 15:23:12.83189+00	2021-11-15 15:23:34.418867+00	ख. कुल पूँजीगत बजेट खर्च रकम	De	f	\N	28	Num	2
82	2021-11-15 15:21:44.15252+00	2021-11-15 15:23:46.621894+00	घ. अपलोड फिल्ड	F	f	\N	27	\N	4
83	2021-11-15 15:23:12.831831+00	2021-11-15 15:23:38.768891+00	क. कुल विनियोजित पूँजीतगत बजेट रकम	De	f	\N	28	Deno	1
86	2021-11-15 15:23:12.831963+00	2021-11-15 15:23:25.858274+00	घ. अपलोड फिल्ड	F	f	\N	28	\N	4
85	2021-11-15 15:23:12.831927+00	2021-11-15 15:23:30.197248+00	ग. खर्च प्रतिशत	P	t	\N	28	Per	3
87	2021-11-15 15:32:07.063217+00	2021-11-15 15:32:39.800509+00	क. लेखा परिक्षण भएको आर्थिक वर्ष	FY	f	\N	29	\N	1
91	2021-11-15 15:32:07.063408+00	2021-11-15 15:32:21.13368+00	ङ. अपलोड फिल्ड	F	f	\N	29	\N	5
90	2021-11-15 15:32:07.06336+00	2021-11-15 15:32:25.957639+00	घ. बेरुजु प्रतिशत	P	t	\N	29	Per	4
89	2021-11-15 15:32:07.063323+00	2021-11-15 15:32:30.033667+00	ग. कायम भएको बेरुजुको रकम	De	f	\N	29	Num	3
88	2021-11-15 15:32:07.063284+00	2021-11-15 15:32:34.491922+00	ख. कुल लेखा परिक्षण गरिएको रकम	De	f	\N	29	Deno	2
98	2021-11-15 15:38:24.32138+00	2021-11-15 15:38:32.095407+00	ग. अपलोड फिल्ड	F	f	\N	31	\N	3
97	2021-11-15 15:38:24.321343+00	2021-11-15 15:38:35.977418+00	ख. आवधिक योजना तर्जुमा नगरेको	B	f	\N	31	\N	2
96	2021-11-15 15:38:24.32128+00	2021-11-15 15:38:39.786117+00	क. आवधिक योजना तर्जुमा गरेको	B	f	\N	31	\N	1
95	2021-11-15 15:34:40.02719+00	2021-11-15 15:38:46.661409+00	घ. अपलोड फिल्ड	F	f	\N	30	\N	4
94	2021-11-15 15:34:40.027155+00	2021-11-15 15:38:51.49992+00	ग. आर्थिक वर्षभरि सुत्रको प्रयोग नगरेको	B	f	\N	30	\N	3
93	2021-11-15 15:34:40.027117+00	2021-11-15 15:38:55.390547+00	ख. कारोवार भइसके पश्चात मात्र तत् सम्बन्धी विवरण सुत्रमा प्रविष्टि गर्ने गरेको	B	f	\N	30	\N	2
92	2021-11-15 15:34:40.027052+00	2021-11-15 15:38:59.336519+00	क. कारोवार भएकै समयमा आर्थिक वर्षको पुरै अवधि निरन्तर रुपमा सुत्रको प्रयोग गरेको	B	f	\N	30	\N	1
114	2021-11-15 16:09:02.016496+00	2021-11-15 16:09:08.082792+00	घ. अपलोड फिल्ड	F	f	\N	34	\N	4
102	2021-11-15 16:04:52.150842+00	2021-11-15 16:06:36.513842+00	घ. अपलोड फिल्ड	F	f	\N	32	\N	4
113	2021-11-15 16:09:02.016469+00	2021-11-15 16:09:13.378924+00	ग. कम्तीमा ×डी" वा सो भन्दा उच्च ग्रेड सहित उतिर्ण विद्यार्थीको प्रतिशत	P	t	\N	34	Per	3
112	2021-11-15 16:09:02.016439+00	2021-11-15 16:09:18.56429+00	ख. परिक्षामा सहभागि विद्यार्थीमध्ये डि श्रेणी (स्तरीकृ त अङ्क (GPA) १.६ वा सो भन्दा उच्च GPA प्राप्त गरेका ) भन्दा उच्च श्रेणी प्राप्त गरी उतिर्ण विद्यार्थीको संख्या	De	f	\N	34	Num	2
111	2021-11-15 16:09:02.016388+00	2021-11-15 16:09:22.825723+00	क. आफ्नो क्षेत्र भित्रका सामुदायिक विद्यालयबाट अघिल्लो शैक्षिक सत्रमा माध्यमिक शिक्षा परिक्षामा सहभागि भएका विद्यार्थीको संख्या	De	f	\N	34	Deno	1
110	2021-11-15 16:07:48.044043+00	2021-11-15 16:07:55.158258+00	घ. अपलोड फिल्ड	F	f	\N	33	\N	4
99	2021-11-15 16:04:52.150688+00	2021-11-15 16:06:19.116979+00	क. पालिका भित्रका विद्यालय जाने उमेर समूहका कुल बालबालिकाको संख्या	De	f	\N	32	Deno	1
100	2021-11-15 16:04:52.150751+00	2021-11-15 16:06:23.244305+00	ख. सोहि उमेर समूहका विद्यालय भर्ना भएका बालबालिकाको संख्या	De	f	\N	32	Num	2
101	2021-11-15 16:04:52.150805+00	2021-11-15 16:06:28.179804+00	ग. खुद भर्ना दर	P	t	\N	32	Per	3
109	2021-11-15 16:07:48.044008+00	2021-11-15 16:07:58.952757+00	ग. टिकाउदर	P	t	\N	33	Per	3
108	2021-11-15 16:07:48.043969+00	2021-11-15 16:08:02.912122+00	ख. चालु शैक्षिक सत्रमा कक्षा ९ मा अध्ययनरत विद्यार्थी संख्या	De	f	\N	33	Num	2
107	2021-11-15 16:07:48.043902+00	2021-11-15 16:08:06.59547+00	क. पालिकाभित्र रहेका सवै विद्यालयहरुमा अघिल्लो शैक्षिक सत्रमा कक्षा ८ मा अध्ययनरत विद्यार्थी संख्या	De	f	\N	33	Deno	1
118	2021-11-15 16:10:19.699191+00	2021-11-15 16:10:25.368628+00	घ. अपलोड फिल्ड	F	f	\N	35	\N	4
117	2021-11-15 16:10:19.699165+00	2021-11-15 16:10:30.574142+00	ग. गर्भ जाँच गर्ने महिलाको प्रतिशत	P	t	\N	35	Per	3
116	2021-11-15 16:10:19.699136+00	2021-11-15 16:10:34.738652+00	ख. स्वास्थ्य संस्थामा गर्भ जाँच गराएका महिलाको संख्या	De	f	\N	35	Num	2
119	2021-11-15 16:12:05.520071+00	2021-11-15 16:12:31.929861+00	क. स्थानीय तह भित्र रहेका कुल गर्भवती महिलाको संख्या	De	f	\N	36	Deno	1
122	2021-11-15 16:12:05.520183+00	2021-11-15 16:12:11.92608+00	घ. अपलोड फिल्ड	F	f	\N	36	\N	4
121	2021-11-15 16:12:05.520156+00	2021-11-15 16:12:16.865746+00	ग. स्वास्थ्य संस्थामा सुत्केरी हुने महिलाको प्रतिशत	P	t	\N	36	Per	3
115	2021-11-15 16:10:19.699086+00	2021-11-15 16:10:39.206073+00	क. स्थानीय तह भित्र रहेका कु ल गर्भवति महिलाको संख्या	De	f	\N	35	Deno	1
120	2021-11-15 16:12:05.520126+00	2021-11-15 16:12:22.114655+00	ख. स्वास्थ्य संस्थामा सुत्केरी भएका महिलाको संख्या	De	f	\N	36	Num	2
124	2021-11-15 16:14:09.679054+00	2021-11-15 16:14:24.913345+00	ख. पूर्ण खोप लगाएका बालबालिकाको संख्या	De	f	\N	37	Num	2
126	2021-11-15 16:14:09.679138+00	2021-11-15 16:14:16.726451+00	घ. अपलोड फिल्ड	F	f	\N	37	\N	4
125	2021-11-15 16:14:09.679103+00	2021-11-15 16:14:21.11368+00	ग. पूर्ण खोप लिएका बालबालिकाको प्रतिशत	P	t	\N	37	Per	3
123	2021-11-15 16:14:09.678978+00	2021-11-15 16:14:28.535229+00	क. स्थानीय तह भित्र रहेका पूर्ण खोप लगाउन पर्ने जन्मे देखि २४ महिनासम्म उमेर समूहका बालबालिकाको संख्या	De	f	\N	37	Deno	1
128	2021-11-15 16:15:17.60061+00	2021-11-15 16:15:26.088352+00	ख. प्रविष्टि नगरेको	B	f	\N	38	\N	2
127	2021-11-15 16:15:17.600558+00	2021-11-15 16:15:33.725195+00	क. प्रविष्टि गरेको	B	f	\N	38	\N	1
12	2021-11-15 13:25:25.243537+00	2021-11-15 17:55:02.101258+00	ङ. अपलोड फिल्ड	F	f	\N	3	\N	5
129	2021-11-15 17:47:05.321169+00	2021-11-15 17:53:30.026304+00	घ. प्रतिशत	P	t	\N	3	Per	4
157	2022-10-20 10:18:00.022405+00	2022-10-20 10:18:00.022424+00	FY	FY	f	\N	53	\N	\N
158	2022-10-20 10:18:00.022456+00	2022-10-20 10:18:00.022477+00	Name	C	f	\N	53	\N	\N
159	2022-10-20 10:18:00.022501+00	2022-10-20 10:18:00.022507+00	Check box	B	f	\N	53	\N	\N
163	2022-10-20 10:18:00.022625+00	2022-10-20 10:18:00.022631+00	file field	F	f	\N	53	\N	\N
162	2022-10-20 10:18:00.022597+00	2022-10-20 10:18:00.025318+00	Percentage	P	t	\N	53	Per	\N
160	2022-10-20 10:18:00.022538+00	2022-10-20 10:18:00.026437+00	Amount N	De	f	\N	53	Num	\N
161	2022-10-20 10:18:00.02257+00	2022-10-20 10:18:00.027374+00	Amount D	De	f	\N	53	Deno	\N
164	2022-10-20 10:23:09.400776+00	2022-10-20 10:23:09.400796+00	char a	C	f	\N	55	\N	\N
165	2022-10-20 10:23:09.400829+00	2022-10-20 10:23:09.400836+00	file field 	F	f	\N	55	\N	\N
166	2022-10-20 10:23:33.674445+00	2022-10-20 10:23:33.674509+00	char b	C	f	\N	56	\N	\N
167	2022-10-20 10:23:33.674563+00	2022-10-20 10:23:33.674575+00	file	F	f	\N	56	\N	\N
\.


--
-- Data for Name: core_provincebody; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_provincebody (id, created_at, updated_at, name, name_np, central_id) FROM stdin;
\.


--
-- Data for Name: core_question; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_question (id, created_at, updated_at, title, is_document_required, month_requires, sequence_id, parent_id, survey_id, is_options_created, department_id) FROM stdin;
1	2021-11-15 13:20:25.52187+00	2022-05-30 05:28:01.520576+00	1. गत आर्थिक वर्ष भन्दा अघिल्लो आर्थिक वर्षको अन्तिम लेखापरिक्षणबाट औल्याएको बेरुजुको अवस्थाः	t	f	1	\N	1	f	1
2	2021-11-15 13:22:01.605363+00	2021-11-15 15:30:51.169477+00	2. प्रदेशले स्थानीय तहलाई प्रदेश कानुन बमोजिम आयोगले तोके को आधार लागु गरी सशर्त अनुदान प्रदान गरे/नगरेकोः	t	f	2	\N	1	f	2
3	2021-11-15 13:23:23.414354+00	2021-11-15 17:47:47.155381+00	3. सवारी साधन करवापत बाँडफाँट गरिएको ४० प्रतिशत रकम प्रदेश सरकारले मासिक रुपमा सम्बन्धित स्थानीय संचित कोषमा जम्मा गरे/नगरेकोः	t	t	3	\N	1	f	2
12	2021-11-15 13:53:17.49738+00	2021-11-15 15:31:39.264212+00	8. प्रदेशले आफ्‍नो बजेट कार्यान्वयनको वार्षिक समिक्षा गरी तत्सम्बन्धी विवरण प्रत्येक वर्षको कार्तिक मसान्तभित्र सार्वजनिक गरे/नगरेको।	t	f	8	\N	1	f	2
6	2021-11-15 13:31:53.916691+00	2021-11-15 15:31:23.821436+00	5. प्रदेशले आफ्नो अधिकार क्षेत्रभित्रको राजस्व परिचालन गरेको अवस्था।	f	f	5	\N	1	t	2
9	2021-11-15 13:36:28.685+00	2021-11-15 15:31:29.199355+00	6. प्रदेश सरकारले स्थानीय तहलाई उपलब्ध गराउने वित्तीय समानीकरण अनुदानको अनुमानित विवरण स्थानीय तहलाई चैत्र मसान्तभित्र उपलब्ध गराएको/नगराएको।	t	f	6	\N	1	f	2
4	2021-11-15 13:28:09.300821+00	2021-11-15 15:31:18.101923+00	4. प्रदेशको गत आर्थिक वर्षको विनियोजित रकम अनुसार खर्चको अवस्थाः	f	f	4	\N	1	t	2
11	2021-11-15 13:51:40.876705+00	2021-11-15 15:43:46.165137+00	7. प्रदेशले आगामी आर्थिक वर्षको लागि आय व्ययको प्रक्षेपण गरिएको तथ्याङ्‍ कसहितको विवरण चालु आ.व.को पुस मसान्तभित्र अर्थ मन्त्रालयमा पेस गरे/नगरेको।	t	f	7	\N	1	f	2
15	2021-11-15 14:01:17.787094+00	2021-11-15 15:30:42.121968+00	11. आयोगले तयार गरेको विद्युतीय अनलाइन पोर्टल (Online Portal) मा कार्य सम्पादन सूचक सम्बन्धी विवरण तोकिएको अवधिमा प्रविष्टि (Upload) गरे/नगरेको।	f	f	11	\N	1	f	4
16	2021-11-15 14:03:06.892519+00	2021-11-15 14:03:34.835913+00	1. गाउँ कार्यपालिका र नगर कार्यपालिकाले प्रत्येक वर्षको असार १० गतेभित्र आगामी आर्थिक वर्षको राजस्व र व्ययको अनुमान सम्बन्धित गाउँ सभा र नगर सभामा पेश गरे/नगरेकोः	t	f	1	\N	2	f	\N
17	2021-11-15 14:03:49.585022+00	2021-11-15 14:04:42.450492+00	2. गाउँ कार्यपालिका र नगर कार्यपालिकाले प्रत्येक वर्षको असार १० गतेभित्र आगामी आर्थिक वर्षको राजस्व र व्ययको अनुमान सम्बन्धित गाउँ सभा र नगर सभामा पेश गरी असार मसान्त भित्र पारित गरे/नगरेकोः	t	f	2	\N	2	f	\N
20	2021-11-15 14:07:55.82505+00	2021-11-15 14:10:01.086425+00	3. स्थानीय तहले घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर वापत उठे को रकममध्ये प्रदेश सरकारलाई दिनुपर्ने ४० प्रतिशत रकम मासिक रुपमा प्रदेश सञ्चित कोषमा जम्मा गरे/नगरेकोः	t	t	3	\N	2	f	\N
21	2021-11-15 14:10:56.896344+00	2021-11-15 14:11:54.217926+00	4. स्थानीय तहले आगामी आर्थिक वर्षको लागि आय व्ययको प्रक्षेपण गरिएको तथ्याङ्‍क सहितको विवरण चालु आर्थिक वर्षको पुस मसान्तभित्र अर्थ मन्त्रालयमा पेस गरे/नगरेको।	t	f	4	\N	2	f	\N
10	2021-11-15 13:40:43.497546+00	2021-11-15 15:30:16.011916+00	(आ) कुल विनियोजित पूँजीगत रकममा कुल पूँजीगत रकमको खर्चको प्रतिशतः	t	f	2	4	1	f	\N
5	2021-11-15 13:29:07.800498+00	2021-11-15 15:30:20.25604+00	(अ) कुल विनियोजित रकममा कुल खर्चको प्रतिशतः	t	f	1	4	1	f	\N
7	2021-11-15 13:34:19.368578+00	2021-11-15 15:30:25.230683+00	(अ) अनुमानित राजस्व प्रक्षेपणको तुलनामा राजस्व सङ्‍कलनको अवस्था	t	f	1	6	1	f	\N
8	2021-11-15 13:36:13.657682+00	2021-11-15 15:30:33.238759+00	(आ) गत आर्थिक वर्षभन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलनको तुलनामा गत आर्थिक वर्षको राजस्व सङ्‍ कलनको अवस्था	t	f	2	6	1	f	\N
14	2021-11-15 13:56:59.49956+00	2021-11-15 15:30:34.668029+00	10. प्रदेश तहमा व्यवस्थित वनले ढाके को क्षेत्रफलमा भएको वृद्धि प्रतिशत	t	f	10	\N	1	f	3
13	2021-11-15 13:55:40.387665+00	2021-11-16 06:01:36.434017+00	9. प्रदेश तहको वायु गुणस्तर सुचकाङ्‍क (Air Quality Index)	t	f	9	\N	1	f	3
22	2021-11-15 14:12:06.547506+00	2021-11-15 14:13:41.539228+00	5. स्थानीय तहले बजेट कार्यान्वयनको वार्षिक समिक्षा गरी तत्सम्बन्धी विवरण प्रत्येक वर्षको कार्तिक मसान्तभित्र सार्वजनिक गरे/नगरेको।	t	f	5	\N	2	f	\N
23	2021-11-15 14:14:30.793542+00	2022-10-20 10:29:52.307742+00	6. स्थानीय तहले आफ्नो अधिकार क्षेत्रभित्रको राजस्व परिचालन गरेको अवस्था।	f	t	6	\N	2	t	\N
33	2021-11-15 16:07:00.991572+00	2021-11-15 16:07:48.042148+00	12. कक्षा ८ को तुलनामा कक्षा ९ मा विद्यार्थी टिकाउ दर	t	f	12	\N	2	f	\N
26	2021-11-15 15:19:15.858623+00	2021-11-15 15:23:12.830343+00	7. स्थानीय तहको गत आर्थिक वर्षको विनियोजित रकम अनुसार खर्चको अवस्था।	f	f	7	\N	2	t	\N
28	2021-11-15 15:23:12.829339+00	2021-11-15 15:29:51.422069+00	आ. कुल विनियोजित पूँजीगत रकममा कुल पूँजीगत रकमको खर्चको प्रतिशतः	t	f	2	26	2	f	\N
27	2021-11-15 15:21:44.149939+00	2021-11-15 15:29:55.99459+00	अ. कुल विनियोजित रकममा कुल खर्चको प्रतिशतः	t	f	1	26	2	f	\N
25	2021-11-15 14:52:36.452868+00	2021-11-15 15:30:01.910357+00	आ. गत आर्थिक वर्षभन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलनको तुलनामा गत आर्थिक वर्षको राजस्व सङ्‍ कलनको अवस्था	t	f	2	23	2	f	\N
24	2021-11-15 14:16:30.137512+00	2021-11-15 15:30:05.925516+00	अ. अनुमानित राजस्व प्रक्षेपण अनुसार राजस्व सङ्‍कलनको अवस्था	t	f	1	23	2	f	\N
29	2021-11-15 15:31:00.039725+00	2021-11-15 15:32:07.061348+00	8. गत आर्थिक वर्ष भन्दा अघिल्लो आर्थिक वर्षको अन्तिम लेखापरिक्षणबाट औल्याएको बेरुजुको अवस्थाः	t	f	8	\N	2	f	\N
30	2021-11-15 15:33:14.435005+00	2021-11-15 15:34:40.025297+00	9. महालेखा नियन्त्रक कार्यालयले प्रयोगमा ल्याएको स्थानीय सञ्‍चित कोष व्यवस्थापन प्रणाली (Subnational Treasury Regulating Application, SUTRA) को प्रयोग स्थानीय तहहरुले पूर्ण रुपमा गरी आवश्‍यक विवरण प्रविष्ट गरे/नगरेको।	t	f	9	\N	2	f	\N
31	2021-11-15 15:37:54.238055+00	2021-11-15 15:38:24.319423+00	10. स्थानीय तहले आफ्नो अधिकार क्षेत्रभित्रका विषयमा स्थानीय स्तरको विकासको लागि आवधिक योजना तर्जुमा गरे/नगरेकोः	t	f	10	\N	2	f	\N
32	2021-11-15 15:39:24.344883+00	2021-11-15 16:04:52.185016+00	11. कक्षा १ देखि ८ सम्मको खुद भर्ना दर	t	f	11	\N	2	f	\N
34	2021-11-15 16:08:23.183092+00	2021-11-15 16:09:02.014964+00	13. सामुदायिक विद्यालयबाट कक्षा १० को परीक्षामा सहभागी कु ल विद्यार्थी संख्याको तुलनामा कम्तीमा स्तरीकृ त अंक (GPA) १.६ वा सो भन्दा उच्च GPA मूल प्रमाणपत्र प्राप्त गरेका विद्यार्थी प्रतिशतः	t	f	13	\N	2	f	\N
35	2021-11-15 16:09:40.570565+00	2021-11-15 16:10:19.697576+00	14. चार (४) पटक गर्भ जाँच गर्ने महिलाको अनुपातः	t	f	14	\N	2	f	\N
36	2021-11-15 16:11:05.219666+00	2021-11-15 16:12:05.518412+00	15. कुल गर्भवति महिलाको संख्यामध्ये स्वास्थ्य संस्थामा सुत्केरी हुने महिलाको अनुपात	t	f	15	\N	2	f	\N
37	2021-11-15 16:13:25.560451+00	2021-11-15 16:14:09.677245+00	16. पूर्ण खोप (विसिजी, पोलियो, डिपिटि-हेपाटाइटिस बी-हिब (पेन्टाभ्यालेन्ट),पी.सी.भी., दादुरा-रुवेला, जापनिज इन्सेफिलाइटिस, कलेरा ) सुविधा लिएका २४ महिनासम्म उमेर समूहका बालबालिकाको अनुपात प्रतिशत।	t	f	16	\N	2	f	\N
38	2021-11-15 16:14:50.477841+00	2021-11-15 16:16:25.079592+00	17. आयोगले तयार गरेको विद्युतीय अनलाइन पोर्टल (Online Portal) मा कार्य सम्पादन सूचक सम्बन्धी विवरण तोकिएको अवधिमा प्रविष्टि (Upload) गरे/नगरेको।	f	f	17	\N	2	f	\N
56	2022-10-20 10:23:33.671837+00	2022-10-20 10:23:33.671868+00	dual question b	f	f	\N	54	1	f	\N
54	2022-10-20 10:22:44.814703+00	2022-10-20 10:23:33.672901+00	dual questios	f	f	15	\N	1	t	\N
53	2022-10-20 10:16:18.550089+00	2022-10-20 10:18:36.056157+00	14. New upadted test suchak	f	f	14	\N	1	f	2
55	2022-10-20 10:23:09.397806+00	2022-10-20 10:23:09.397834+00	dual question a	f	f	\N	54	1	f	\N
\.


--
-- Data for Name: core_survey; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_survey (id, created_at, updated_at, name, level, approval_state, is_active, fiscal_year_id) FROM stdin;
1	2021-11-15 13:20:25.519974+00	2021-11-15 13:20:25.520018+00	प्रदेश सरकारको हकमा	P	P	t	1
2	2021-11-15 14:03:06.891228+00	2021-11-15 14:03:06.891252+00	स्थानीय सरकारको हकमा	L	P	t	1
\.


--
-- Data for Name: core_surveycorrection; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.core_surveycorrection (id, created_at, updated_at, sub, msg, document, status, question_id, user_id, level_id, month) FROM stdin;
11	2022-06-01 15:56:08.79898+00	2022-06-01 15:56:08.799007+00	change value 90 to 80	sudarnu paryo	correction-files/garage-logo.svg	P	2	14	3	\N
12	2022-06-02 09:17:45.149588+00	2022-06-02 09:17:45.149624+00	change garnu to to 40	plese check	correction-files/invoice-logo.png	P	2	14	3	\N
13	2022-06-02 09:17:45.174398+00	2022-06-02 09:17:45.174423+00	change garnu to to 40	plese check	correction-files/invoice-logo_OcHCcbC.png	P	2	14	3	\N
14	2022-07-25 05:07:16.904635+00	2022-07-25 05:08:55.791009+00	please change the correction document	change in correction document	correction-files/Screenshot_2022-07-07_17-18-20.png	C	2	15	5	\N
15	2022-10-20 10:05:38.429268+00	2022-10-20 10:06:16.921429+00	request for correction 	description\r\nchange 9000 to 90000\r\nchange 10000 to 100000	correction-files/Get_Started_With_Smallpdf_d9m1kAa.pdf	C	2	43	4	\N
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2021-11-15 13:12:10.829299+00	1	२०७८/७९	1	[{"added": {}}]	18	1
2	2021-11-15 13:13:15.705442+00	2	२०७७/७८	1	[{"added": {}}]	18	1
3	2021-11-15 13:14:46.168145+00	3	२०७९/८०	1	[{"added": {}}]	18	1
4	2021-11-15 13:26:09.378036+00	1	क. लेखा परिक्षण भएको आर्थिक वर्ष	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
5	2021-11-15 13:26:13.195312+00	2	ख. कुल लेखा परिक्षण गरिएको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
6	2021-11-15 13:26:17.655262+00	3	ग. कायम भएको बेरुजुको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
7	2021-11-15 13:26:21.462594+00	4	घ. बेरुजु प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
8	2021-11-15 13:26:26.710881+00	5	ङ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
9	2021-11-15 13:26:31.777001+00	6	क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
10	2021-11-15 13:26:35.904834+00	7	ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
11	2021-11-15 13:26:39.899111+00	8	ग. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
12	2021-11-15 13:26:44.321237+00	9	क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
13	2021-11-15 13:26:48.576089+00	10	ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
14	2021-11-15 13:26:53.360241+00	11	ग. जम्मा गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
15	2021-11-15 13:27:02.707176+00	12	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
16	2021-11-15 13:32:20.640421+00	13	क. कुल विनियोजित बजेट रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
17	2021-11-15 13:32:25.248136+00	14	ख. कुल खर्च भएको बजेट रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
18	2021-11-15 13:32:29.640289+00	15	ग. खर्च प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
19	2021-11-15 13:32:32.982767+00	16	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
20	2021-11-15 13:37:44.697591+00	17	क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
21	2021-11-15 13:42:12.416789+00	32	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
22	2021-11-15 13:42:17.315914+00	31	ग. खर्च प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
23	2021-11-15 13:42:22.213599+00	30	ख. कुल पूँजीगत बजेट खर्च रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
24	2021-11-15 13:42:25.660619+00	29	क. कुल विनियोजित पूँजीतगत बजेट रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
25	2021-11-15 13:42:31.643286+00	28	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
26	2021-11-15 13:42:36.052998+00	27	ग. चैत्र मसान्त भित्र उपलब्ध नगराएको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
27	2021-11-15 13:42:44.032974+00	26	ख. उपलब्ध गराएको मितिः	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
28	2021-11-15 13:42:49.431969+00	25	क. चैत्र मसान्त भित्र उपलब्ध गराएको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
29	2021-11-15 13:42:53.889098+00	24	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
30	2021-11-15 13:42:59.295921+00	23	ग. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकमको तुलनामा गत आर्थिक वर्षको राजस्व सङ्कलन रकममा भएको बृद्धि प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
31	2021-11-15 13:47:56.067966+00	22	ख. गत आर्थिक वर्षको राजस्व सङ्कलन रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
32	2021-11-15 13:48:19.614859+00	21	क. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
33	2021-11-15 13:48:32.4638+00	20	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
34	2021-11-15 13:48:36.721075+00	19	ग. राजस्व सङ्कलन प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
35	2021-11-15 13:48:41.532835+00	18	ख. यथार्थ सङ्कलन भएको राजस्व	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
36	2021-11-15 13:48:47.044394+00	17	क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य	2	[]	22	1
37	2021-11-15 13:52:51.362625+00	36	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
38	2021-11-15 13:52:55.986919+00	35	ग. पुस मसान्तभित्र पेश नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
39	2021-11-15 13:53:00.613566+00	34	ख. पेश गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
40	2021-11-15 13:53:04.686232+00	33	क. पुस मसान्तभित्र पेश गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
41	2021-11-15 13:55:48.141691+00	41	ङ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
42	2021-11-15 13:55:52.351991+00	40	घ. सार्वजनिक गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
43	2021-11-15 13:55:56.680317+00	39	ग. वार्षिक समिक्षा भए समिक्षा गरेको गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
44	2021-11-15 13:56:02.452018+00	38	ख. वार्षिक समिक्षा नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
45	2021-11-15 13:56:06.654403+00	37	क. वार्षिक समिक्षा गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
46	2021-11-15 13:57:10.496754+00	44	ग. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
47	2021-11-15 13:57:14.193045+00	43	ख. वायुको गुणस्तरको अवस्था सुधार नभएको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
48	2021-11-15 13:57:17.821447+00	42	क. वायुको गुणस्तरको अवस्था सुधार भएको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
49	2021-11-15 13:58:57.225922+00	47	ग. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
50	2021-11-15 13:59:01.618654+00	46	ख. पछिल्लो आर्थिक वर्ष समुदायमा आधारित वन व्यवस्थापन गरिएको वनको क्षेत्रफल	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
51	2021-11-15 13:59:05.196717+00	45	क. अघिल्लो आर्थिक वर्षसम्मको समुदायमा आधारित वन व्यवस्थापन गरिएको वनको क्षेत्रफल	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
52	2021-11-15 14:01:57.141555+00	49	ख. प्रविष्टि नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
53	2021-11-15 14:02:02.443065+00	48	क. प्रविष्टि गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
54	2021-11-15 14:04:30.332161+00	50	क. असार १० गते भित्र आय व्ययको अनुमान पेश गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
55	2021-11-15 14:04:34.52177+00	51	ख. असार १० गते पछि आय व्ययको अनुमान पेश गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
56	2021-11-15 14:04:39.309272+00	52	ग. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
57	2021-11-15 14:04:52.993235+00	55	ग. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
58	2021-11-15 14:04:56.939247+00	54	ख. असार १० गते भित्र राजस्व र व्यको अनुमान पेश गरी असार मसान्त भित्र पारित नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
59	2021-11-15 14:05:04.460949+00	53	क. असार १० गते भित्र राजस्व र व्यको अनुमान पेश गरी असार मसान्त भित्र पारित गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
60	2021-11-15 14:10:27.80514+00	59	क. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
61	2021-11-15 14:10:32.872382+00	60	ख. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकमको ४० प्रतिशतले हुने रकम प्रदेश सञ्चित कोषमा जम्मा गरेको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
62	2021-11-15 14:10:37.236044+00	61	ग. जम्मा गरेको मिति।	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
63	2021-11-15 14:10:42.720436+00	62	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
64	2021-11-15 14:12:30.281244+00	66	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
65	2021-11-15 14:12:35.10045+00	65	ग. पुस मसान्तभित्र पेश नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
66	2021-11-15 14:12:40.051742+00	64	ख. पेश गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
67	2021-11-15 14:12:43.686367+00	63	क. पुस मसान्तभित्र पेश गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
68	2021-11-15 14:13:49.123484+00	70	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
69	2021-11-15 14:13:53.690991+00	69	ग. वार्षिक समिक्षा नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
70	2021-11-15 14:13:57.873344+00	68	ख. समिक्षा सम्बन्धी विवरण सार्वजनिक गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
71	2021-11-15 14:14:02.454337+00	67	क. वार्षिक समिक्षा गरेको मिति	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
72	2021-11-15 14:50:35.560135+00	71	क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
73	2021-11-15 14:50:42.832638+00	72	ख. यथार्थ सङ्कलन भएको राजस्व	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
74	2021-11-15 14:50:47.97486+00	73	ग. प्रक्षेपित लक्ष्यमा राजस्व सङ्कलन प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
75	2021-11-15 14:50:52.42127+00	74	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
76	2021-11-15 14:52:44.749865+00	78	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
77	2021-11-15 14:52:48.870061+00	77	ग. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकमको तुलनामा गत आर्थिक वर्षको राजस्व सङ्कलन रकममा भएको बृद्धि प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
78	2021-11-15 14:52:52.682617+00	76	ख. गत आर्थिक वर्षको राजस्व सङ्कलन रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
79	2021-11-15 14:52:58.036499+00	75	क. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
80	2021-11-15 15:23:25.859797+00	86	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
81	2021-11-15 15:23:30.198451+00	85	ग. खर्च प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
82	2021-11-15 15:23:34.420345+00	84	ख. कुल पूँजीगत बजेट खर्च रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
83	2021-11-15 15:23:38.770164+00	83	क. कुल विनियोजित पूँजीतगत बजेट रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
84	2021-11-15 15:23:46.623093+00	82	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
85	2021-11-15 15:25:30.199507+00	81	ग. खर्च प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
86	2021-11-15 15:28:32.536113+00	79	क. कुल विनियोजित बजेट रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
87	2021-11-15 15:28:37.824212+00	80	ख. कुल खर्च भएको बजेट रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
88	2021-11-15 15:28:41.273032+00	81	ग. खर्च प्रतिशत	2	[]	22	1
89	2021-11-15 15:29:51.423632+00	28	आ. कुल विनियोजित पूँजीगत रकममा कुल पूँजीगत रकमको खर्चको प्रतिशतः	2	[{"changed": {"fields": ["Title", "Sequence id"]}}]	20	1
90	2021-11-15 15:29:55.996141+00	27	अ. कुल विनियोजित रकममा कुल खर्चको प्रतिशतः	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
91	2021-11-15 15:30:01.911836+00	25	आ. गत आर्थिक वर्षभन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलनको तुलनामा गत आर्थिक वर्षको राजस्व सङ्‍ कलनको अवस्था	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
92	2021-11-15 15:30:05.927125+00	24	अ. अनुमानित राजस्व प्रक्षेपण अनुसार राजस्व सङ्‍कलनको अवस्था	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
93	2021-11-15 15:30:16.013323+00	10	(आ) कुल विनियोजित पूँजीगत रकममा कुल पूँजीगत रकमको खर्चको प्रतिशतः	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
94	2021-11-15 15:30:20.257277+00	5	(अ) कुल विनियोजित रकममा कुल खर्चको प्रतिशतः	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
95	2021-11-15 15:30:25.232249+00	7	(अ) अनुमानित राजस्व प्रक्षेपणको तुलनामा राजस्व सङ्‍कलनको अवस्था	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
96	2021-11-15 15:30:33.240389+00	8	(आ) गत आर्थिक वर्षभन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलनको तुलनामा गत आर्थिक वर्षको राजस्व सङ्‍ कलनको अवस्था	2	[{"changed": {"fields": ["Sequence id"]}}]	20	1
97	2021-11-15 15:32:21.134917+00	91	ङ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
98	2021-11-15 15:32:25.958866+00	90	घ. बेरुजु प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
99	2021-11-15 15:32:30.035143+00	89	ग. कायम भएको बेरुजुको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
100	2021-11-15 15:32:34.493476+00	88	ख. कुल लेखा परिक्षण गरिएको रकम	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
101	2021-11-15 15:32:39.801752+00	87	क. लेखा परिक्षण भएको आर्थिक वर्ष	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
102	2021-11-15 15:38:32.096663+00	98	ग. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
103	2021-11-15 15:38:35.978725+00	97	ख. आवधिक योजना तर्जुमा नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
104	2021-11-15 15:38:39.78733+00	96	क. आवधिक योजना तर्जुमा गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
105	2021-11-15 15:38:46.66265+00	95	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
106	2021-11-15 15:38:51.501403+00	94	ग. आर्थिक वर्षभरि सुत्रको प्रयोग नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
107	2021-11-15 15:38:55.39181+00	93	ख. कारोवार भइसके पश्चात मात्र तत् सम्बन्धी विवरण सुत्रमा प्रविष्टि गर्ने गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
108	2021-11-15 15:38:59.337748+00	92	क. कारोवार भएकै समयमा आर्थिक वर्षको पुरै अवधि निरन्तर रुपमा सुत्रको प्रयोग गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
109	2021-11-15 16:05:01.48826+00	106	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
110	2021-11-15 16:05:05.84558+00	105	ग. खुद भर्ना दर	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
111	2021-11-15 16:05:10.180621+00	104	ख. सोहि उमेर समूहका विद्यालय भर्ना भएका बालबालिकाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
112	2021-11-15 16:05:15.412164+00	103	क. पालिका भित्रका विद्यालय जाने उमेर समूहका कुल बालबालिकाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
113	2021-11-15 16:06:10.511911+00	106	घ. अपलोड फिल्ड	3		22	1
114	2021-11-15 16:06:10.514007+00	105	ग. खुद भर्ना दर	3		22	1
115	2021-11-15 16:06:10.515013+00	104	ख. सोहि उमेर समूहका विद्यालय भर्ना भएका बालबालिकाको संख्या	3		22	1
116	2021-11-15 16:06:10.515954+00	103	क. पालिका भित्रका विद्यालय जाने उमेर समूहका कुल बालबालिकाको संख्या	3		22	1
117	2021-11-15 16:06:19.118452+00	99	क. पालिका भित्रका विद्यालय जाने उमेर समूहका कुल बालबालिकाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
118	2021-11-15 16:06:23.245537+00	100	ख. सोहि उमेर समूहका विद्यालय भर्ना भएका बालबालिकाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
119	2021-11-15 16:06:28.181286+00	101	ग. खुद भर्ना दर	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
120	2021-11-15 16:06:33.352494+00	102	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
121	2021-11-15 16:06:36.515314+00	102	घ. अपलोड फिल्ड	2	[]	22	1
122	2021-11-15 16:07:55.159969+00	110	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
123	2021-11-15 16:07:58.954051+00	109	ग. टिकाउदर	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
124	2021-11-15 16:08:02.913428+00	108	ख. चालु शैक्षिक सत्रमा कक्षा ९ मा अध्ययनरत विद्यार्थी संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
125	2021-11-15 16:08:06.596984+00	107	क. पालिकाभित्र रहेका सवै विद्यालयहरुमा अघिल्लो शैक्षिक सत्रमा कक्षा ८ मा अध्ययनरत विद्यार्थी संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
126	2021-11-15 16:09:08.084506+00	114	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
127	2021-11-15 16:09:13.380335+00	113	ग. कम्तीमा ×डी" वा सो भन्दा उच्च ग्रेड सहित उतिर्ण विद्यार्थीको प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
128	2021-11-15 16:09:18.565847+00	112	ख. परिक्षामा सहभागि विद्यार्थीमध्ये डि श्रेणी (स्तरीकृ त अङ्क (GPA) १.६ वा सो भन्दा उच्च GPA प्राप्त गरेका ) भन्दा उच्च श्रेणी प्राप्त गरी उतिर्ण विद्यार्थीको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
129	2021-11-15 16:09:22.826984+00	111	क. आफ्नो क्षेत्र भित्रका सामुदायिक विद्यालयबाट अघिल्लो शैक्षिक सत्रमा माध्यमिक शिक्षा परिक्षामा सहभागि भएका विद्यार्थीको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
130	2021-11-15 16:10:25.370146+00	118	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
131	2021-11-15 16:10:30.575603+00	117	ग. गर्भ जाँच गर्ने महिलाको प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
132	2021-11-15 16:10:34.739868+00	116	ख. स्वास्थ्य संस्थामा गर्भ जाँच गराएका महिलाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
133	2021-11-15 16:10:39.20742+00	115	क. स्थानीय तह भित्र रहेका कु ल गर्भवति महिलाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
134	2021-11-15 16:12:11.92759+00	122	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
135	2021-11-15 16:12:16.866987+00	121	ग. स्वास्थ्य संस्थामा सुत्केरी हुने महिलाको प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
136	2021-11-15 16:12:22.116169+00	120	ख. स्वास्थ्य संस्थामा सुत्केरी भएका महिलाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
137	2021-11-15 16:12:31.931353+00	119	क. स्थानीय तह भित्र रहेका कुल गर्भवती महिलाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
138	2021-11-15 16:14:16.72767+00	126	घ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
139	2021-11-15 16:14:21.11522+00	125	ग. पूर्ण खोप लिएका बालबालिकाको प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
140	2021-11-15 16:14:24.914784+00	124	ख. पूर्ण खोप लगाएका बालबालिकाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
141	2021-11-15 16:14:28.536459+00	123	क. स्थानीय तह भित्र रहेका पूर्ण खोप लगाउन पर्ने जन्मे देखि २४ महिनासम्म उमेर समूहका बालबालिकाको संख्या	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
142	2021-11-15 16:15:26.089985+00	128	ख. प्रविष्टि नगरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
143	2021-11-15 16:15:33.726673+00	127	क. प्रविष्टि गरेको	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
144	2021-11-15 16:16:25.081096+00	38	17. आयोगले तयार गरेको विद्युतीय अनलाइन पोर्टल (Online Portal) मा कार्य सम्पादन सूचक सम्बन्धी विवरण तोकिएको अवधिमा प्रविष्टि (Upload) गरे/नगरेको।	2	[{"changed": {"fields": ["Title"]}}]	20	1
145	2021-11-15 17:53:30.027519+00	129	घ. प्रतिशत	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
146	2021-11-15 17:55:02.102725+00	12	ङ. अपलोड फिल्ड	2	[{"changed": {"fields": ["Sequence id"]}}]	22	1
147	2021-11-15 18:02:50.181764+00	54	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
148	2021-11-15 18:02:50.183653+00	53	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
149	2021-11-15 18:02:50.184545+00	52	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
150	2021-11-15 18:02:50.185347+00	51	29 90 घ. बेरुजु प्रतिशत 90	3		16	1
151	2021-11-15 18:02:50.186118+00	50	29 89 ग. कायम भएको बेरुजुको रकम 180000	3		16	1
152	2021-11-15 18:02:50.186875+00	49	29 88 ख. कुल लेखा परिक्षण गरिएको रकम 200000	3		16	1
153	2021-11-15 18:02:50.18763+00	48	29 91 ङ. अपलोड फिल्ड test.json	3		16	1
154	2021-11-15 18:03:14.20719+00	3	स्थानीय सरकारको हकमा, अग्मीसयर कृष्ण सवरन गाउँपालिका	3		24	1
155	2021-11-15 18:03:21.582202+00	1	स्थानीय सरकारको हकमा, ककनी गाउँपालिका	3		24	1
156	2021-11-15 18:17:19.101165+00	24	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Correction checked"]}}]	29	1
426	2022-06-01 08:17:18.33951+00	391	3 11 ग. जम्मा गरेको मिति 2078-07-12	3		16	1
157	2021-11-15 18:17:31.106915+00	21	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Correction checked"]}}]	29	1
158	2021-11-15 18:17:46.455256+00	19	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
159	2021-11-15 18:17:53.582084+00	19	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
160	2021-11-15 18:17:58.234619+00	18	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
161	2021-11-15 18:18:03.091605+00	15	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
162	2021-11-15 18:18:07.022689+00	14	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
163	2021-11-15 18:18:10.083099+00	14	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
164	2021-11-15 18:18:13.301338+00	15	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
165	2021-11-15 18:18:17.983852+00	16	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
166	2021-11-15 18:18:22.347799+00	17	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
167	2021-11-15 18:18:25.38982+00	18	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
168	2021-11-15 18:18:27.98361+00	19	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
169	2021-11-15 18:18:30.972309+00	20	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
170	2021-11-15 18:18:34.853008+00	21	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
171	2021-11-15 18:18:40.593368+00	12	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
172	2021-11-15 18:18:47.059702+00	10	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
173	2021-11-15 18:19:12.394751+00	1	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
174	2021-11-15 18:19:17.627522+00	3	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
175	2021-11-15 18:19:23.633119+00	4	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
176	2021-11-15 18:19:29.386378+00	5	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा पठाइएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
177	2021-11-15 18:19:40.763116+00	6	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा पठाइएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
178	2021-11-15 18:19:57.228145+00	7	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
179	2021-11-15 18:21:34.574495+00	9	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा पठाइएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
180	2021-11-15 18:25:01.506103+00	35	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
181	2021-11-15 18:25:10.93446+00	34	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
182	2021-11-15 18:25:51.674297+00	33	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
183	2021-11-15 18:26:04.573663+00	36	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
184	2021-11-15 18:26:08.472537+00	37	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
185	2021-11-15 18:26:12.083212+00	38	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
186	2021-11-15 18:26:15.48707+00	33	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
187	2021-11-15 18:26:20.547049+00	32	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
188	2021-11-15 18:26:23.48732+00	32	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[]	29	1
189	2021-11-15 18:26:57.468722+00	25	नयाँ सर्वेक्षण राप्ती नगरपालिका को प्रयोगकर्ता haribahadur_rapti@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
190	2021-11-15 18:27:22.343637+00	40	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
191	2021-11-15 18:27:32.402364+00	41	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
192	2021-11-15 18:27:35.845519+00	42	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	2	[{"changed": {"fields": ["Is viewed"]}}]	29	1
193	2021-11-16 04:02:12.931414+00	11	प्रदेश सरकारको हकमा, None	3		24	1
194	2021-11-16 05:08:41.084849+00	1	http://192.168.50.45:1337	2	[{"changed": {"fields": ["Domain name", "Display name"]}}]	6	1
195	2021-11-16 05:21:44.722395+00	1	192.168.50.45:1337	2	[{"changed": {"fields": ["Domain name", "Display name"]}}]	6	1
196	2021-11-17 04:58:56.988319+00	12	मूल्याङ्कन पुनरावलोकन सम्बन्धी गुनासो (CODE:appraisal_review_request)	2	[{"changed": {"fields": ["Name"]}}]	7	1
197	2021-11-17 04:59:30.584819+00	11	प्रतिवेदनहरु (CODE:reports)	2	[{"changed": {"fields": ["Name"]}}]	7	1
198	2021-11-19 10:54:02.437141+00	1	admin@mail.com	2	[{"changed": {"fields": ["Full Name", "Personal Email", "Level"]}}]	10	1
199	2021-11-22 07:00:56.904702+00	13	स्थानीय सरकारको हकमा, None	3		24	1
200	2021-12-12 05:55:42.454331+00	101	नयाँ सूचक फक्ताङ्लुङ्ग गाउँपालिका को प्रयोगकर्ता gita_panauti@yopmail.com द्वारा भरीएको छ।	3		29	1
201	2021-12-12 05:55:42.458103+00	100	तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।	3		29	1
202	2021-12-12 05:55:42.459147+00	99	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता bitta_ayog_pradesh2@yopmail.com द्वारा पठाइएको छ।	3		29	1
203	2021-12-12 05:55:42.460143+00	98	नयाँ सूचक राप्ती नगरपालिका को प्रयोगकर्ता haribahadur_rapti@yopmail.com द्वारा भरीएको छ।	3		29	1
204	2021-12-12 05:55:42.461146+00	97	नयाँ सूचक राप्ती नगरपालिका को प्रयोगकर्ता haribahadur_rapti@yopmail.com द्वारा भरीएको छ।	3		29	1
205	2021-12-12 05:55:42.462118+00	96	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता haribahadur_rapti@yopmail.com द्वारा पठाइएको छ।	3		29	1
206	2021-12-12 05:55:42.463119+00	95	नयाँ सूचक None को प्रयोगकर्ता admin@mail.com द्वारा भरीएको छ।	3		29	1
207	2021-12-12 05:55:42.463999+00	94	तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।	3		29	1
208	2021-12-12 05:55:42.464862+00	93	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा पठाइएको छ।	3		29	1
209	2021-12-12 05:55:42.465735+00	92	तपाइँको सुधार अनुरोध एडमिन द्वारा जाँच गरीयो।	3		29	1
210	2021-12-12 05:55:42.466581+00	91	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
211	2021-12-12 05:55:42.467468+00	90	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
212	2021-12-12 05:55:42.468342+00	89	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
213	2021-12-12 05:55:42.469248+00	88	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
214	2021-12-12 05:55:42.470115+00	87	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
215	2021-12-12 05:55:42.47097+00	86	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
216	2021-12-12 05:55:42.471877+00	85	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
217	2021-12-12 05:55:42.472771+00	84	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
218	2021-12-12 05:55:42.473634+00	83	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
219	2021-12-12 05:55:42.474513+00	82	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
220	2021-12-12 05:55:42.475392+00	81	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
427	2022-06-01 08:17:18.340327+00	390	3 129 घ. प्रतिशत 35.38461538461539	3		16	1
221	2021-12-12 05:55:42.47626+00	80	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
222	2021-12-12 05:55:42.477188+00	79	नयाँ सर्वेक्षण Province No. 1 को प्रयोगकर्ता province1_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
223	2021-12-12 05:55:42.478057+00	78	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
224	2021-12-12 05:55:42.478907+00	77	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
225	2021-12-12 05:55:42.479787+00	76	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
226	2021-12-12 05:55:42.480636+00	75	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
227	2021-12-12 05:55:42.481499+00	74	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
228	2021-12-12 05:55:42.482362+00	73	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
229	2021-12-12 05:55:42.483227+00	72	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
230	2021-12-12 05:55:42.484112+00	71	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
231	2021-12-12 05:55:42.48496+00	70	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
232	2021-12-12 05:55:42.485824+00	69	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
233	2021-12-12 05:55:42.486674+00	68	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
234	2021-12-12 05:55:42.487539+00	67	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
235	2021-12-12 05:55:42.488408+00	66	नयाँ सर्वेक्षण Lumbini Province को प्रयोगकर्ता lumbini_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
236	2021-12-12 05:55:42.489282+00	65	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
237	2021-12-12 05:55:42.490151+00	64	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
238	2021-12-12 05:55:42.491001+00	63	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
239	2021-12-12 05:55:42.491858+00	62	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
240	2021-12-12 05:55:42.492715+00	61	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
241	2021-12-12 05:55:42.493556+00	60	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
242	2021-12-12 05:55:42.494421+00	59	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
243	2021-12-12 05:55:42.495279+00	58	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
244	2021-12-12 05:55:42.49617+00	57	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
245	2021-12-12 05:55:42.497028+00	56	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
246	2021-12-12 05:55:42.497876+00	55	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
247	2021-12-12 05:55:42.498731+00	54	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
248	2021-12-12 05:55:42.499594+00	53	नयाँ सर्वेक्षण Bagmati Province को प्रयोगकर्ता bagmati_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
249	2021-12-12 05:55:42.50046+00	52	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
250	2021-12-12 05:55:42.501326+00	51	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
251	2021-12-12 05:55:42.502192+00	50	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
252	2021-12-12 05:55:42.503056+00	49	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
253	2021-12-12 05:55:42.503904+00	48	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
558	2022-06-01 08:17:40.391687+00	259	3 129 घ. प्रतिशत 40	3		16	1
254	2021-12-12 05:55:42.504771+00	47	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
255	2021-12-12 05:55:42.50566+00	46	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
256	2021-12-12 05:55:42.506528+00	45	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
257	2021-12-12 05:55:42.50742+00	44	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
258	2021-12-12 05:55:42.508288+00	43	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
259	2021-12-12 05:55:42.509157+00	42	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
260	2021-12-12 05:55:42.51003+00	41	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
261	2021-12-12 05:55:42.510892+00	40	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
262	2021-12-12 05:55:42.511766+00	39	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
263	2021-12-12 05:55:42.512618+00	38	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
264	2021-12-12 05:55:42.513484+00	37	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
265	2021-12-12 05:55:42.514348+00	36	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
266	2021-12-12 05:55:42.515213+00	35	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
267	2021-12-12 05:55:42.516079+00	34	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
268	2021-12-12 05:55:42.516924+00	33	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
269	2021-12-12 05:55:42.517787+00	32	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
270	2021-12-12 05:55:42.518652+00	31	नयाँ सर्वेक्षण Province No. 2 को प्रयोगकर्ता province2_arthik@yopmail.com द्वारा भरीएको छ।	3		29	1
271	2021-12-12 05:55:42.519539+00	30	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
272	2021-12-12 05:55:42.52041+00	29	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
273	2021-12-12 05:55:42.521276+00	28	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
274	2021-12-12 05:55:42.522145+00	27	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
275	2021-12-12 05:55:42.52301+00	26	नयाँ सर्वेक्षण राप्ती नगरपालिका को प्रयोगकर्ता haribahadur_rapti@yopmail.com द्वारा भरीएको छ।	3		29	1
276	2021-12-12 05:55:42.523878+00	25	नयाँ सर्वेक्षण राप्ती नगरपालिका को प्रयोगकर्ता haribahadur_rapti@yopmail.com द्वारा भरीएको छ।	3		29	1
277	2021-12-12 05:55:42.524745+00	24	नयाँ सर्वेक्षण Gandaki Province को प्रयोगकर्ता moeap.gandaki@yopmail.com द्वारा भरीएको छ।	3		29	1
278	2021-12-12 05:55:42.525596+00	23	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	3		29	1
279	2021-12-12 05:55:42.526464+00	22	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	3		29	1
280	2021-12-12 05:55:42.527334+00	21	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
281	2021-12-12 05:55:42.528194+00	20	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
282	2021-12-12 05:55:42.529069+00	19	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
283	2021-12-12 05:55:42.529937+00	18	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
284	2021-12-12 05:55:42.530805+00	17	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
285	2021-12-12 05:55:42.531657+00	16	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
645	2022-06-01 08:17:40.460987+00	172	3 11 ग. जम्मा गरेको मिति 2078-07-07	3		16	1
646	2022-06-01 08:17:40.461818+00	171	3 129 घ. प्रतिशत 40	3		16	1
286	2021-12-12 05:55:42.532523+00	15	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
287	2021-12-12 05:55:42.533424+00	14	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
288	2021-12-12 05:55:42.534292+00	13	नयाँ सर्वेक्षण अग्मीसयर कृष्ण सवरन गाउँपालिका को प्रयोगकर्ता kamalyadav_agnisairmun@yopmail.com द्वारा भरीएको छ।	3		29	1
289	2021-12-12 05:55:42.535173+00	12	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
290	2021-12-12 05:55:42.536041+00	11	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
291	2021-12-12 05:55:42.536899+00	10	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
292	2021-12-12 05:55:42.537761+00	9	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा पठाइएको छ।	3		29	1
293	2021-12-12 05:55:42.538612+00	8	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
294	2021-12-12 05:55:42.539498+00	7	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	3		29	1
295	2021-12-12 05:55:42.540361+00	6	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा पठाइएको छ।	3		29	1
296	2021-12-12 05:55:42.541251+00	5	नयाँ सुधार अनुमति सूचक प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा पठाइएको छ।	3		29	1
297	2021-12-12 05:55:42.542118+00	4	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	3		29	1
298	2021-12-12 05:55:42.542969+00	3	नयाँ सर्वेक्षण ककनी गाउँपालिका को प्रयोगकर्ता mohanshrestha_galchhimun@yopmail.com द्वारा भरीएको छ।	3		29	1
299	2021-12-12 05:55:42.543835+00	2	नयाँ सर्वेक्षण Karnali Province को प्रयोगकर्ता sharmabharatkumar11@yopmail.com द्वारा भरीएको छ।	3		29	1
300	2022-06-01 08:16:24.063298+00	10	test	3		26	1
301	2022-06-01 08:16:24.068032+00	9	Re: request for correction	3		26	1
302	2022-06-01 08:16:24.06961+00	8	Request for correction	3		26	1
303	2022-06-01 08:16:24.070824+00	7	Re: Request for evaluation	3		26	1
304	2022-06-01 08:16:24.071846+00	6	Re: Request for correction suchak 2	3		26	1
305	2022-06-01 08:16:24.07277+00	5	Request for correction, Q7	3		26	1
306	2022-06-01 08:16:24.073661+00	4	Correction request	3		26	1
307	2022-06-01 08:16:24.074472+00	3	Sudhar Suchak No. 1 ko Ka	3		26	1
308	2022-06-01 08:16:24.075325+00	2	Rakam ma sudhar gardinu hola	3		26	1
309	2022-06-01 08:16:24.076113+00	1	Rakam ma sudhar gardinu hola	3		26	1
310	2022-06-01 08:16:37.103658+00	10	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
311	2022-06-01 08:16:37.105411+00	9	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
312	2022-06-01 08:16:37.106349+00	8	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
313	2022-06-01 08:16:37.107257+00	7	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
314	2022-06-01 08:16:37.108111+00	6	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
315	2022-06-01 08:16:37.109071+00	5	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
316	2022-06-01 08:16:37.109972+00	4	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
317	2022-06-01 08:16:37.110758+00	3	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
318	2022-06-01 08:16:37.111546+00	2	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
319	2022-06-01 08:16:37.112456+00	1	admin@mail.com: सुधार अनुमति सूचक चेक गरियो।	3		27	1
320	2022-06-01 08:16:48.196147+00	5	Re: Slow loading	3		28	1
321	2022-06-01 08:16:48.197935+00	4	Re: General Complaint	3		28	1
322	2022-06-01 08:16:48.198896+00	3	asd	3		28	1
323	2022-06-01 08:16:48.199792+00	2	Re: General Complaint 2	3		28	1
324	2022-06-01 08:16:48.200649+00	1	Re: server issue	3		28	1
325	2022-06-01 08:17:03.210012+00	11	re: evaluation for marks	3		30	1
326	2022-06-01 08:17:03.211876+00	10	revision request 	3		30	1
327	2022-06-01 08:17:03.212809+00	9	Evaluation complaint for suchak 3	3		30	1
328	2022-06-01 08:17:03.21375+00	8	re: evaluation for marks 	3		30	1
329	2022-06-01 08:17:03.214616+00	7	Re: Evaluation Request	3		30	1
330	2022-06-01 08:17:03.215517+00	6	Re: Re evaluation	3		30	1
331	2022-06-01 08:17:03.216385+00	5	Re: Re evaluation	3		30	1
332	2022-06-01 08:17:03.217319+00	4	Re: Re evaluation	3		30	1
333	2022-06-01 08:17:03.218241+00	3	Re: Re evaluation	3		30	1
334	2022-06-01 08:17:03.219004+00	2	Re: Re evaluation	3		30	1
335	2022-06-01 08:17:03.219775+00	1	Re: Mulyankan for question 	3		30	1
336	2022-06-01 08:17:18.26513+00	485	9 26 ख. उपलब्ध गराएको मितिः 2078-12-16	3		16	1
337	2022-06-01 08:17:18.267103+00	484	9 27 ग. चैत्र मसान्त भित्र उपलब्ध नगराएको False	3		16	1
338	2022-06-01 08:17:18.268081+00	483	9 25 क. चैत्र मसान्त भित्र उपलब्ध गराएको True	3		16	1
339	2022-06-01 08:17:18.269004+00	482	9 28 घ. अपलोड फिल्ड Get_Started_With_Smallpdf.pdf	3		16	1
340	2022-06-01 08:17:18.26992+00	481	25 77 ग. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकमको तुलनामा गत आर्थिक वर्षको राजस्व सङ्कलन रकममा भएको बृद्धि प्रतिशत 50	3		16	1
341	2022-06-01 08:17:18.270893+00	480	25 76 ख. गत आर्थिक वर्षको राजस्व सङ्कलन रकम 250009	3		16	1
342	2022-06-01 08:17:18.271781+00	479	25 75 क. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकम 500000	3		16	1
343	2022-06-01 08:17:18.272605+00	478	24 73 ग. प्रक्षेपित लक्ष्यमा राजस्व सङ्कलन प्रतिशत 50	3		16	1
344	2022-06-01 08:17:18.273426+00	477	24 72 ख. यथार्थ सङ्कलन भएको राजस्व 20000	3		16	1
345	2022-06-01 08:17:18.274246+00	476	24 71 क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य 40000	3		16	1
346	2022-06-01 08:17:18.275055+00	475	25 78 घ. अपलोड फिल्ड Get_Started_With_Smallpdf.pdf	3		16	1
347	2022-06-01 08:17:18.275919+00	474	24 74 घ. अपलोड फिल्ड Get_Started_With_Smallpdf.pdf	3		16	1
348	2022-06-01 08:17:18.276725+00	473	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
349	2022-06-01 08:17:18.277513+00	472	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
350	2022-06-01 08:17:18.278313+00	471	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
351	2022-06-01 08:17:18.279113+00	470	29 90 घ. बेरुजु प्रतिशत 150	3		16	1
352	2022-06-01 08:17:18.27995+00	469	29 89 ग. कायम भएको बेरुजुको रकम 3000	3		16	1
353	2022-06-01 08:17:18.280756+00	468	29 88 ख. कुल लेखा परिक्षण गरिएको रकम 2000	3		16	1
354	2022-06-01 08:17:18.281627+00	467	29 91 ङ. अपलोड फिल्ड Get_Started_With_Smallpdf.pdf	3		16	1
355	2022-06-01 08:17:18.282523+00	466	14 46 ख. पछिल्लो आर्थिक वर्ष समुदायमा आधारित वन व्यवस्थापन गरिएको वनको क्षेत्रफल 4000002	3		16	1
356	2022-06-01 08:17:18.283321+00	465	14 45 क. अघिल्लो आर्थिक वर्षसम्मको समुदायमा आधारित वन व्यवस्थापन गरिएको वनको क्षेत्रफल 200000	3		16	1
357	2022-06-01 08:17:18.284111+00	464	14 47 ग. अपलोड फिल्ड nepal_govt.jpg	3		16	1
358	2022-06-01 08:17:18.284914+00	463	12 40 घ. सार्वजनिक गरेको मिति 2078-08-07	3		16	1
359	2022-06-01 08:17:18.28571+00	462	12 39 ग. वार्षिक समिक्षा भए समिक्षा गरेको गरेको मिति 2078-08-28	3		16	1
360	2022-06-01 08:17:18.286506+00	461	12 38 ख. वार्षिक समिक्षा नगरेको False	3		16	1
361	2022-06-01 08:17:18.287303+00	460	12 37 क. वार्षिक समिक्षा गरेको True	3		16	1
362	2022-06-01 08:17:18.288088+00	459	12 41 ङ. अपलोड फिल्ड Inception Document NNRFC.pdf	3		16	1
363	2022-06-01 08:17:18.288892+00	458	16 51 ख. असार १० गते पछि आय व्ययको अनुमान पेश गरेको True	3		16	1
364	2022-06-01 08:17:18.289684+00	457	16 50 क. असार १० गते भित्र आय व्ययको अनुमान पेश गरेको True	3		16	1
365	2022-06-01 08:17:18.290467+00	456	16 52 ग. अपलोड फिल्ड Screenshot 2021-11-25 at 09-53-01 NNRFC.png	3		16	1
366	2022-06-01 08:17:18.291246+00	455	20 61 ग. जम्मा गरेको मिति। 2078-08-07	3		16	1
367	2022-06-01 08:17:18.292075+00	454	20 60 ख. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकमको ४० प्रतिशतले हुने रकम प्रदेश सञ्चित कोषमा जम्मा गरेको रकम 50000	3		16	1
368	2022-06-01 08:17:18.29289+00	453	20 59 क. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकम 200000	3		16	1
369	2022-06-01 08:17:18.293687+00	452	20 62 घ. अपलोड फिल्ड Get_Started_With_Smallpdf.pdf	3		16	1
370	2022-06-01 08:17:18.294464+00	451	20 61 ग. जम्मा गरेको मिति। 2078-08-06	3		16	1
371	2022-06-01 08:17:18.295322+00	450	20 60 ख. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकमको ४० प्रतिशतले हुने रकम प्रदेश सञ्चित कोषमा जम्मा गरेको रकम 20000	3		16	1
372	2022-06-01 08:17:18.296107+00	449	20 59 क. यस महिनामा सङ्कलन भएको घर जग्गा रजिस्ट्रे शन शुल्क, मनोरञ्जन कर तथा विज्ञापन कर रकम 50000	3		16	1
373	2022-06-01 08:17:18.296952+00	448	20 62 घ. अपलोड फिल्ड Get_Started_With_Smallpdf.pdf	3		16	1
374	2022-06-01 08:17:18.297753+00	447	16 51 ख. असार १० गते पछि आय व्ययको अनुमान पेश गरेको True	3		16	1
375	2022-06-01 08:17:18.298672+00	446	16 50 क. असार १० गते भित्र आय व्ययको अनुमान पेश गरेको True	3		16	1
376	2022-06-01 08:17:18.299451+00	445	16 52 ग. अपलोड फिल्ड Province name.docx	3		16	1
377	2022-06-01 08:17:18.300239+00	443	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
378	2022-06-01 08:17:18.30101+00	439	2 8 ग. अपलोड फिल्ड test.txt	3		16	1
379	2022-06-01 08:17:18.301785+00	438	2 8 ग. अपलोड फिल्ड test.txt	3		16	1
380	2022-06-01 08:17:18.302619+00	437	1 5 ङ. अपलोड फिल्ड iis.zip	3		16	1
381	2022-06-01 08:17:18.30339+00	436	3 11 ग. जम्मा गरेको मिति 2078-07-20	3		16	1
382	2022-06-01 08:17:18.304209+00	435	3 129 घ. प्रतिशत 36	3		16	1
383	2022-06-01 08:17:18.304991+00	434	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 45000	3		16	1
384	2022-06-01 08:17:18.305838+00	433	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 125000	3		16	1
385	2022-06-01 08:17:18.306645+00	432	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
386	2022-06-01 08:17:18.307429+00	431	3 11 ग. जम्मा गरेको मिति 2078-07-11	3		16	1
387	2022-06-01 08:17:18.308244+00	430	3 129 घ. प्रतिशत 34.48275862068966	3		16	1
388	2022-06-01 08:17:18.309014+00	429	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 60000	3		16	1
389	2022-06-01 08:17:18.309798+00	428	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 174000	3		16	1
390	2022-06-01 08:17:18.310578+00	427	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
391	2022-06-01 08:17:18.311349+00	426	3 11 ग. जम्मा गरेको मिति 2078-07-16	3		16	1
392	2022-06-01 08:17:18.312147+00	425	3 129 घ. प्रतिशत 36.11111111111111	3		16	1
393	2022-06-01 08:17:18.31298+00	424	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 65000	3		16	1
394	2022-06-01 08:17:18.31385+00	423	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
395	2022-06-01 08:17:18.31466+00	422	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
396	2022-06-01 08:17:18.315464+00	421	3 11 ग. जम्मा गरेको मिति 	3		16	1
397	2022-06-01 08:17:18.316278+00	420	3 129 घ. प्रतिशत 40	3		16	1
398	2022-06-01 08:17:18.317244+00	419	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 70000	3		16	1
399	2022-06-01 08:17:18.318029+00	418	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 175000	3		16	1
400	2022-06-01 08:17:18.318843+00	417	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
401	2022-06-01 08:17:18.319651+00	416	3 11 ग. जम्मा गरेको मिति 2078-07-04	3		16	1
402	2022-06-01 08:17:18.320424+00	415	3 129 घ. प्रतिशत 36.84210526315789	3		16	1
403	2022-06-01 08:17:18.3212+00	414	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 70000	3		16	1
404	2022-06-01 08:17:18.321978+00	413	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 190000	3		16	1
405	2022-06-01 08:17:18.322752+00	412	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
406	2022-06-01 08:17:18.323536+00	411	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
407	2022-06-01 08:17:18.324305+00	410	3 129 घ. प्रतिशत 39.39393939393939	3		16	1
408	2022-06-01 08:17:18.325073+00	409	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 65000	3		16	1
409	2022-06-01 08:17:18.3261+00	408	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 165000	3		16	1
410	2022-06-01 08:17:18.326892+00	407	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
411	2022-06-01 08:17:18.327668+00	406	3 11 ग. जम्मा गरेको मिति 2078-07-12	3		16	1
412	2022-06-01 08:17:18.328463+00	405	3 129 घ. प्रतिशत 40	3		16	1
413	2022-06-01 08:17:18.329232+00	404	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 68000	3		16	1
414	2022-06-01 08:17:18.330001+00	403	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 170000	3		16	1
415	2022-06-01 08:17:18.330775+00	402	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
416	2022-06-01 08:17:18.331558+00	401	3 11 ग. जम्मा गरेको मिति 2078-07-03	3		16	1
417	2022-06-01 08:17:18.332333+00	400	3 129 घ. प्रतिशत 36.11111111111111	3		16	1
418	2022-06-01 08:17:18.33318+00	399	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 65000	3		16	1
419	2022-06-01 08:17:18.333959+00	398	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
420	2022-06-01 08:17:18.334753+00	397	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
421	2022-06-01 08:17:18.335555+00	396	3 11 ग. जम्मा गरेको मिति 2078-07-03	3		16	1
422	2022-06-01 08:17:18.336334+00	395	3 129 घ. प्रतिशत 37.93103448275862	3		16	1
423	2022-06-01 08:17:18.337162+00	394	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 55000	3		16	1
424	2022-06-01 08:17:18.337943+00	393	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 145000	3		16	1
425	2022-06-01 08:17:18.338723+00	392	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
428	2022-06-01 08:17:18.341154+00	389	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 46000	3		16	1
429	2022-06-01 08:17:18.341971+00	388	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 130000	3		16	1
430	2022-06-01 08:17:18.342749+00	387	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
431	2022-06-01 08:17:18.343524+00	386	3 11 ग. जम्मा गरेको मिति 2078-07-11	3		16	1
432	2022-06-01 08:17:18.34429+00	385	3 129 घ. प्रतिशत 37.5	3		16	1
433	2022-06-01 08:17:18.345054+00	384	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 45000	3		16	1
434	2022-06-01 08:17:18.345864+00	383	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 120000	3		16	1
435	2022-06-01 08:17:18.346636+00	382	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
436	2022-06-01 08:17:40.290102+00	381	3 11 ग. जम्मा गरेको मिति 2078-07-04	3		16	1
437	2022-06-01 08:17:40.292164+00	380	3 129 घ. प्रतिशत 40	3		16	1
438	2022-06-01 08:17:40.293151+00	379	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 40000	3		16	1
439	2022-06-01 08:17:40.29404+00	378	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 100000	3		16	1
440	2022-06-01 08:17:40.294941+00	377	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
441	2022-06-01 08:17:40.295854+00	376	2 7 ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम 40000	3		16	1
442	2022-06-01 08:17:40.296747+00	375	2 6 क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम 110000	3		16	1
443	2022-06-01 08:17:40.297544+00	374	2 8 ग. अपलोड फिल्ड sample2.txt	3		16	1
444	2022-06-01 08:17:40.298335+00	373	3 11 ग. जम्मा गरेको मिति 2078-07-02	3		16	1
445	2022-06-01 08:17:40.299149+00	372	3 129 घ. प्रतिशत 386.3636363636364	3		16	1
446	2022-06-01 08:17:40.299938+00	371	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 850000	3		16	1
447	2022-06-01 08:17:40.300743+00	370	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 220000	3		16	1
448	2022-06-01 08:17:40.301548+00	369	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
449	2022-06-01 08:17:40.302358+00	368	3 11 ग. जम्मा गरेको मिति 2078-07-11	3		16	1
450	2022-06-01 08:17:40.303268+00	367	3 129 घ. प्रतिशत 40	3		16	1
451	2022-06-01 08:17:40.304102+00	366	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 80000	3		16	1
452	2022-06-01 08:17:40.304912+00	365	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 200000	3		16	1
453	2022-06-01 08:17:40.305716+00	364	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
454	2022-06-01 08:17:40.30655+00	363	3 11 ग. जम्मा गरेको मिति 	3		16	1
455	2022-06-01 08:17:40.307497+00	362	3 129 घ. प्रतिशत 39.473684210526315	3		16	1
456	2022-06-01 08:17:40.308289+00	361	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 75000	3		16	1
457	2022-06-01 08:17:40.309097+00	360	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 190000	3		16	1
458	2022-06-01 08:17:40.309936+00	359	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
459	2022-06-01 08:17:40.3108+00	358	3 11 ग. जम्मा गरेको मिति 2078-07-11	3		16	1
460	2022-06-01 08:17:40.311606+00	357	3 129 घ. प्रतिशत 40	3		16	1
461	2022-06-01 08:17:40.312389+00	356	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 72000	3		16	1
462	2022-06-01 08:17:40.31319+00	355	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
463	2022-06-01 08:17:40.313992+00	354	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
464	2022-06-01 08:17:40.314828+00	353	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
465	2022-06-01 08:17:40.315691+00	352	3 129 घ. प्रतिशत 40	3		16	1
466	2022-06-01 08:17:40.316511+00	351	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 72000	3		16	1
467	2022-06-01 08:17:40.317343+00	350	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
468	2022-06-01 08:17:40.318149+00	349	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
469	2022-06-01 08:17:40.318973+00	348	3 11 ग. जम्मा गरेको मिति 2078-07-11	3		16	1
470	2022-06-01 08:17:40.319769+00	347	3 129 घ. प्रतिशत 38.23529411764706	3		16	1
471	2022-06-01 08:17:40.320596+00	346	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 65000	3		16	1
472	2022-06-01 08:17:40.321474+00	345	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 170000	3		16	1
473	2022-06-01 08:17:40.322268+00	344	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
474	2022-06-01 08:17:40.323055+00	343	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
475	2022-06-01 08:17:40.324007+00	342	3 129 घ. प्रतिशत 40	3		16	1
476	2022-06-01 08:17:40.324824+00	341	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 60000	3		16	1
477	2022-06-01 08:17:40.325682+00	340	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 150000	3		16	1
478	2022-06-01 08:17:40.32651+00	339	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
479	2022-06-01 08:17:40.327325+00	338	3 11 ग. जम्मा गरेको मिति 2078-07-03	3		16	1
480	2022-06-01 08:17:40.328177+00	337	3 129 घ. प्रतिशत 40	3		16	1
481	2022-06-01 08:17:40.328966+00	336	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 56000	3		16	1
482	2022-06-01 08:17:40.329791+00	335	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 140000	3		16	1
483	2022-06-01 08:17:40.330603+00	334	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
484	2022-06-01 08:17:40.331389+00	333	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
485	2022-06-01 08:17:40.332195+00	332	3 129 घ. प्रतिशत 38.46153846153847	3		16	1
486	2022-06-01 08:17:40.332972+00	331	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 50000	3		16	1
487	2022-06-01 08:17:40.333779+00	330	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 130000	3		16	1
488	2022-06-01 08:17:40.334567+00	329	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
489	2022-06-01 08:17:40.335387+00	328	3 11 ग. जम्मा गरेको मिति 	3		16	1
490	2022-06-01 08:17:40.336178+00	327	3 129 घ. प्रतिशत 37.5	3		16	1
491	2022-06-01 08:17:40.336959+00	326	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 45000	3		16	1
492	2022-06-01 08:17:40.337833+00	325	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 120000	3		16	1
493	2022-06-01 08:17:40.338626+00	324	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
494	2022-06-01 08:17:40.339499+00	323	3 11 ग. जम्मा गरेको मिति 2078-07-04	3		16	1
495	2022-06-01 08:17:40.340318+00	322	3 129 घ. प्रतिशत 36.36363636363637	3		16	1
496	2022-06-01 08:17:40.341106+00	321	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 40000	3		16	1
497	2022-06-01 08:17:40.341916+00	320	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 110000	3		16	1
498	2022-06-01 08:17:40.34273+00	319	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
499	2022-06-01 08:17:40.343523+00	318	3 11 ग. जम्मा गरेको मिति 2078-07-02	3		16	1
500	2022-06-01 08:17:40.34432+00	317	3 129 घ. प्रतिशत 40	3		16	1
501	2022-06-01 08:17:40.345371+00	316	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 40000	3		16	1
502	2022-06-01 08:17:40.346346+00	315	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 100000	3		16	1
503	2022-06-01 08:17:40.347147+00	314	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
504	2022-06-01 08:17:40.34794+00	313	2 7 ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम 40000	3		16	1
505	2022-06-01 08:17:40.348738+00	312	2 6 क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम 100000	3		16	1
506	2022-06-01 08:17:40.349545+00	311	2 8 ग. अपलोड फिल्ड sample2.txt	3		16	1
507	2022-06-01 08:17:40.350349+00	310	3 11 ग. जम्मा गरेको मिति 2078-07-02	3		16	1
508	2022-06-01 08:17:40.351123+00	309	3 129 घ. प्रतिशत 39.130434782608695	3		16	1
509	2022-06-01 08:17:40.351954+00	308	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 90000	3		16	1
510	2022-06-01 08:17:40.352756+00	307	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 230000	3		16	1
511	2022-06-01 08:17:40.35356+00	306	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
512	2022-06-01 08:17:40.354345+00	305	3 11 ग. जम्मा गरेको मिति 2078-07-12	3		16	1
513	2022-06-01 08:17:40.355121+00	304	3 129 घ. प्रतिशत 36.36363636363637	3		16	1
514	2022-06-01 08:17:40.355929+00	303	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 80000	3		16	1
515	2022-06-01 08:17:40.356758+00	302	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 220000	3		16	1
516	2022-06-01 08:17:40.357556+00	301	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
517	2022-06-01 08:17:40.358342+00	300	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
518	2022-06-01 08:17:40.359116+00	299	3 129 घ. प्रतिशत 40	3		16	1
519	2022-06-01 08:17:40.35991+00	298	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 80000	3		16	1
520	2022-06-01 08:17:40.360706+00	297	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 200000	3		16	1
521	2022-06-01 08:17:40.361504+00	296	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
522	2022-06-01 08:17:40.36229+00	295	3 11 ग. जम्मा गरेको मिति 2078-07-04	3		16	1
523	2022-06-01 08:17:40.363074+00	294	3 129 घ. प्रतिशत 36.84210526315789	3		16	1
524	2022-06-01 08:17:40.363912+00	293	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 70000	3		16	1
525	2022-06-01 08:17:40.364731+00	292	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 190000	3		16	1
526	2022-06-01 08:17:40.365543+00	291	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
527	2022-06-01 08:17:40.366379+00	290	3 11 ग. जम्मा गरेको मिति 2078-07-17	3		16	1
528	2022-06-01 08:17:40.367182+00	289	3 129 घ. प्रतिशत 40	3		16	1
529	2022-06-01 08:17:40.367982+00	288	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 72000	3		16	1
530	2022-06-01 08:17:40.36879+00	287	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
531	2022-06-01 08:17:40.369603+00	286	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
532	2022-06-01 08:17:40.370377+00	285	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
533	2022-06-01 08:17:40.371168+00	284	3 129 घ. प्रतिशत 40	3		16	1
534	2022-06-01 08:17:40.37195+00	283	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 68000	3		16	1
535	2022-06-01 08:17:40.37275+00	282	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 170000	3		16	1
536	2022-06-01 08:17:40.373544+00	281	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
537	2022-06-01 08:17:40.374348+00	280	3 11 ग. जम्मा गरेको मिति 2078-07-14	3		16	1
538	2022-06-01 08:17:40.37524+00	279	3 129 घ. प्रतिशत 40	3		16	1
539	2022-06-01 08:17:40.376053+00	278	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 64000	3		16	1
540	2022-06-01 08:17:40.376847+00	277	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 160000	3		16	1
541	2022-06-01 08:17:40.377701+00	276	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
542	2022-06-01 08:17:40.378543+00	275	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
543	2022-06-01 08:17:40.379412+00	274	3 129 घ. प्रतिशत 40	3		16	1
544	2022-06-01 08:17:40.380206+00	273	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 60000	3		16	1
545	2022-06-01 08:17:40.380983+00	272	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 150000	3		16	1
546	2022-06-01 08:17:40.381779+00	271	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
547	2022-06-01 08:17:40.382566+00	270	3 11 ग. जम्मा गरेको मिति 2078-07-08	3		16	1
548	2022-06-01 08:17:40.383349+00	269	3 129 घ. प्रतिशत 40	3		16	1
549	2022-06-01 08:17:40.384143+00	268	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 56000	3		16	1
550	2022-06-01 08:17:40.384922+00	267	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 140000	3		16	1
551	2022-06-01 08:17:40.385725+00	266	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
552	2022-06-01 08:17:40.386508+00	265	3 11 ग. जम्मा गरेको मिति 2078-07-02	3		16	1
553	2022-06-01 08:17:40.387366+00	264	3 129 घ. प्रतिशत 40	3		16	1
554	2022-06-01 08:17:40.388222+00	263	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 52000	3		16	1
555	2022-06-01 08:17:40.389263+00	262	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 130000	3		16	1
556	2022-06-01 08:17:40.39007+00	261	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
557	2022-06-01 08:17:40.390868+00	260	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
559	2022-06-01 08:17:40.392548+00	258	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 48000	3		16	1
560	2022-06-01 08:17:40.39337+00	257	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 120000	3		16	1
561	2022-06-01 08:17:40.394163+00	256	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
562	2022-06-01 08:17:40.394934+00	255	3 11 ग. जम्मा गरेको मिति 2078-07-01	3		16	1
563	2022-06-01 08:17:40.395757+00	254	3 129 घ. प्रतिशत 40	3		16	1
564	2022-06-01 08:17:40.396557+00	253	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 40000	3		16	1
565	2022-06-01 08:17:40.397338+00	252	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 100000	3		16	1
566	2022-06-01 08:17:40.398146+00	251	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
567	2022-06-01 08:17:40.398976+00	250	2 7 ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम 60000	3		16	1
568	2022-06-01 08:17:40.399817+00	249	2 6 क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम 20000	3		16	1
569	2022-06-01 08:17:40.400605+00	248	2 8 ग. अपलोड फिल्ड sample2_1hiCh18.txt	3		16	1
570	2022-06-01 08:17:40.401379+00	247	3 11 ग. जम्मा गरेको मिति 2078-07-12	3		16	1
571	2022-06-01 08:17:40.40219+00	246	3 129 घ. प्रतिशत 37.5	3		16	1
572	2022-06-01 08:17:40.402959+00	245	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 90000	3		16	1
573	2022-06-01 08:17:40.403754+00	244	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 240000	3		16	1
574	2022-06-01 08:17:40.404542+00	243	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
575	2022-06-01 08:17:40.405329+00	242	3 11 ग. जम्मा गरेको मिति 2078-07-10	3		16	1
576	2022-06-01 08:17:40.406105+00	241	3 129 घ. प्रतिशत 34.78260869565217	3		16	1
577	2022-06-01 08:17:40.406886+00	240	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 80000	3		16	1
578	2022-06-01 08:17:40.407697+00	239	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 230000	3		16	1
579	2022-06-01 08:17:40.408497+00	238	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
580	2022-06-01 08:17:40.409294+00	237	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
581	2022-06-01 08:17:40.410063+00	236	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
582	2022-06-01 08:17:40.410908+00	235	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
583	2022-06-01 08:17:40.411724+00	234	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
584	2022-06-01 08:17:40.412511+00	233	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
585	2022-06-01 08:17:40.413293+00	232	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
586	2022-06-01 08:17:40.414064+00	231	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
587	2022-06-01 08:17:40.414877+00	230	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
588	2022-06-01 08:17:40.415685+00	229	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
589	2022-06-01 08:17:40.416465+00	228	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
590	2022-06-01 08:17:40.417249+00	227	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
591	2022-06-01 08:17:40.418044+00	226	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
592	2022-06-01 08:17:40.418874+00	225	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
593	2022-06-01 08:17:40.419785+00	224	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
594	2022-06-01 08:17:40.420579+00	223	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
595	2022-06-01 08:17:40.421353+00	222	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
596	2022-06-01 08:17:40.422127+00	221	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
597	2022-06-01 08:17:40.422943+00	220	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
598	2022-06-01 08:17:40.423747+00	219	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
599	2022-06-01 08:17:40.424554+00	218	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
600	2022-06-01 08:17:40.425352+00	217	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
601	2022-06-01 08:17:40.426146+00	216	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
602	2022-06-01 08:17:40.426928+00	215	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
603	2022-06-01 08:17:40.427767+00	214	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
604	2022-06-01 08:17:40.428592+00	213	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
605	2022-06-01 08:17:40.42936+00	212	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
606	2022-06-01 08:17:40.430144+00	211	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
607	2022-06-01 08:17:40.430923+00	210	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
608	2022-06-01 08:17:40.431712+00	209	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
609	2022-06-01 08:17:40.432494+00	208	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
610	2022-06-01 08:17:40.433271+00	207	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
611	2022-06-01 08:17:40.434067+00	206	3 129 घ. प्रतिशत 40.74074074074074	3		16	1
612	2022-06-01 08:17:40.434863+00	205	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 110000	3		16	1
613	2022-06-01 08:17:40.435674+00	204	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 270000	3		16	1
614	2022-06-01 08:17:40.436473+00	203	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
615	2022-06-01 08:17:40.437253+00	202	3 11 ग. जम्मा गरेको मिति 2078-07-27	3		16	1
616	2022-06-01 08:17:40.438039+00	201	3 129 घ. प्रतिशत 34.285714285714285	3		16	1
617	2022-06-01 08:17:40.438843+00	200	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 240000	3		16	1
618	2022-06-01 08:17:40.439636+00	199	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 700000	3		16	1
619	2022-06-01 08:17:40.440423+00	198	3 12 ङ. अपलोड फिल्ड test (copy).txt	3		16	1
620	2022-06-01 08:17:40.441202+00	197	3 11 ग. जम्मा गरेको मिति 2078-07-09	3		16	1
621	2022-06-01 08:17:40.441971+00	196	3 129 घ. प्रतिशत 40	3		16	1
622	2022-06-01 08:17:40.442754+00	195	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 112000	3		16	1
623	2022-06-01 08:17:40.443554+00	194	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 280000	3		16	1
624	2022-06-01 08:17:40.444341+00	193	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
625	2022-06-01 08:17:40.445128+00	192	3 11 ग. जम्मा गरेको मिति 2078-07-29	3		16	1
626	2022-06-01 08:17:40.445952+00	191	3 129 घ. प्रतिशत 42.857142857142854	3		16	1
627	2022-06-01 08:17:40.446742+00	190	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 30000	3		16	1
628	2022-06-01 08:17:40.447529+00	189	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 70000	3		16	1
629	2022-06-01 08:17:40.448322+00	188	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
630	2022-06-01 08:17:40.449151+00	187	3 11 ग. जम्मा गरेको मिति 2078-07-08	3		16	1
631	2022-06-01 08:17:40.449929+00	186	3 129 घ. प्रतिशत 40	3		16	1
632	2022-06-01 08:17:40.450712+00	185	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 100000	3		16	1
633	2022-06-01 08:17:40.451502+00	184	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 250000	3		16	1
634	2022-06-01 08:17:40.452277+00	183	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
635	2022-06-01 08:17:40.453047+00	182	3 11 ग. जम्मा गरेको मिति 2078-07-22	3		16	1
636	2022-06-01 08:17:40.453833+00	181	3 129 घ. प्रतिशत 40	3		16	1
637	2022-06-01 08:17:40.454615+00	180	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 180000	3		16	1
638	2022-06-01 08:17:40.455405+00	179	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 450000	3		16	1
639	2022-06-01 08:17:40.45619+00	178	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
640	2022-06-01 08:17:40.457001+00	177	3 11 ग. जम्मा गरेको मिति 2078-07-24	3		16	1
641	2022-06-01 08:17:40.457809+00	176	3 129 घ. प्रतिशत 40	3		16	1
642	2022-06-01 08:17:40.458619+00	175	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 200000	3		16	1
643	2022-06-01 08:17:40.459427+00	174	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 500000	3		16	1
644	2022-06-01 08:17:40.46021+00	173	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
647	2022-06-01 08:17:40.462612+00	170	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 96000	3		16	1
648	2022-06-01 08:17:40.463437+00	169	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 240000	3		16	1
649	2022-06-01 08:17:40.464219+00	168	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
650	2022-06-01 08:17:40.465006+00	167	3 11 ग. जम्मा गरेको मिति 2078-07-02	3		16	1
651	2022-06-01 08:17:40.465825+00	166	3 129 घ. प्रतिशत 40	3		16	1
652	2022-06-01 08:17:40.466608+00	165	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 160000	3		16	1
653	2022-06-01 08:17:40.467383+00	164	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 400000	3		16	1
654	2022-06-01 08:17:40.468173+00	163	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
655	2022-06-01 08:17:40.469025+00	162	3 11 ग. जम्मा गरेको मिति 2078-07-23	3		16	1
656	2022-06-01 08:17:40.469862+00	161	3 129 घ. प्रतिशत 40.33333333333333	3		16	1
657	2022-06-01 08:17:40.470648+00	160	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 121000	3		16	1
658	2022-06-01 08:17:40.471429+00	159	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 300000	3		16	1
659	2022-06-01 08:17:40.472207+00	158	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
660	2022-06-01 08:17:40.472979+00	157	3 11 ग. जम्मा गरेको मिति 2078-07-06	3		16	1
661	2022-06-01 08:17:40.473762+00	156	3 129 घ. प्रतिशत 40	3		16	1
662	2022-06-01 08:17:40.474568+00	155	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 88000	3		16	1
663	2022-06-01 08:17:40.475395+00	154	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 220000	3		16	1
664	2022-06-01 08:17:40.476188+00	153	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
665	2022-06-01 08:17:40.476962+00	152	3 11 ग. जम्मा गरेको मिति 2078-07-23	3		16	1
666	2022-06-01 08:17:40.477749+00	151	3 129 घ. प्रतिशत 35	3		16	1
667	2022-06-01 08:17:40.478547+00	150	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 70000	3		16	1
668	2022-06-01 08:17:40.47935+00	149	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 200000	3		16	1
669	2022-06-01 08:17:40.480173+00	148	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
670	2022-06-01 08:17:40.480943+00	147	3 11 ग. जम्मा गरेको मिति 2078-07-05	3		16	1
671	2022-06-01 08:17:40.481727+00	146	3 129 घ. प्रतिशत 40	3		16	1
672	2022-06-01 08:17:40.482517+00	145	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 80000	3		16	1
673	2022-06-01 08:17:40.483335+00	144	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 200000	3		16	1
674	2022-06-01 08:17:40.484207+00	143	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
675	2022-06-01 08:17:40.485+00	142	2 7 ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम 250000	3		16	1
676	2022-06-01 08:17:40.485879+00	141	2 6 क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम 890000	3		16	1
677	2022-06-01 08:17:40.486819+00	140	2 8 ग. अपलोड फिल्ड question.title_reports.xlsx	3		16	1
678	2022-06-01 08:17:40.487634+00	139	3 11 ग. जम्मा गरेको मिति 2078-07-04	3		16	1
679	2022-06-01 08:17:40.488471+00	138	3 129 घ. प्रतिशत 40	3		16	1
680	2022-06-01 08:17:40.489273+00	137	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 72000	3		16	1
681	2022-06-01 08:17:40.490049+00	136	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
682	2022-06-01 08:17:40.490841+00	135	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
683	2022-06-01 08:17:40.491635+00	134	3 11 ग. जम्मा गरेको मिति 2078-07-03	3		16	1
684	2022-06-01 08:17:40.492459+00	133	3 129 घ. प्रतिशत 40	3		16	1
685	2022-06-01 08:17:40.493276+00	132	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 64000	3		16	1
686	2022-06-01 08:17:40.494062+00	131	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 160000	3		16	1
687	2022-06-01 08:17:40.494847+00	130	3 12 ङ. अपलोड फिल्ड sample3.txt	3		16	1
688	2022-06-01 08:17:40.495656+00	129	3 11 ग. जम्मा गरेको मिति 2078-07-03	3		16	1
689	2022-06-01 08:17:40.49648+00	128	3 129 घ. प्रतिशत 40	3		16	1
778	2022-06-01 08:17:40.567755+00	32	2 7 ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम 60000	3		16	1
690	2022-06-01 08:17:40.497263+00	127	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 56000	3		16	1
691	2022-06-01 08:17:40.498104+00	126	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 140000	3		16	1
692	2022-06-01 08:17:40.49893+00	125	3 12 ङ. अपलोड फिल्ड sample2.txt	3		16	1
693	2022-06-01 08:17:40.499734+00	124	3 11 ग. जम्मा गरेको मिति 2078-07-02	3		16	1
694	2022-06-01 08:17:40.500518+00	123	3 129 घ. प्रतिशत 40	3		16	1
695	2022-06-01 08:17:40.501292+00	122	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 48000	3		16	1
696	2022-06-01 08:17:40.502069+00	121	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 120000	3		16	1
697	2022-06-01 08:17:40.502857+00	120	3 12 ङ. अपलोड फिल्ड SampleTextFile.txt	3		16	1
698	2022-06-01 08:17:40.503673+00	119	32 101 ग. खुद भर्ना दर 60	3		16	1
699	2022-06-01 08:17:40.504466+00	118	32 100 ख. सोहि उमेर समूहका विद्यालय भर्ना भएका बालबालिकाको संख्या 120000	3		16	1
700	2022-06-01 08:17:40.505264+00	117	32 99 क. पालिका भित्रका विद्यालय जाने उमेर समूहका कुल बालबालिकाको संख्या 200000	3		16	1
701	2022-06-01 08:17:40.506038+00	116	32 102 घ. अपलोड फिल्ड local_name.csv	3		16	1
702	2022-06-01 08:17:40.506922+00	115	28 85 ग. खर्च प्रतिशत 90	3		16	1
703	2022-06-01 08:17:40.507732+00	114	28 84 ख. कुल पूँजीगत बजेट खर्च रकम 100000	3		16	1
704	2022-06-01 08:17:40.508523+00	113	28 83 क. कुल विनियोजित पूँजीतगत बजेट रकम 250000	3		16	1
705	2022-06-01 08:17:40.509311+00	112	27 81 ग. खर्च प्रतिशत 90	3		16	1
706	2022-06-01 08:17:40.510153+00	111	27 80 ख. कुल खर्च भएको बजेट रकम 180000	3		16	1
707	2022-06-01 08:17:40.510932+00	110	27 79 क. कुल विनियोजित बजेट रकम 200000	3		16	1
708	2022-06-01 08:17:40.511722+00	109	28 86 घ. अपलोड फिल्ड nepali_english_glossary.pdf	3		16	1
709	2022-06-01 08:17:40.512507+00	108	2 7 ख. आधार पालना नगरी विनियोजन गरिएको सशर्त अनुदानको रकम 48000	3		16	1
710	2022-06-01 08:17:40.513287+00	107	2 6 क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम 200000	3		16	1
711	2022-06-01 08:17:40.514057+00	106	2 8 ग. अपलोड फिल्ड filename_M3KP0I9.txt	3		16	1
712	2022-06-01 08:17:40.514845+00	105	32 101 ग. खुद भर्ना दर 70	3		16	1
713	2022-06-01 08:17:40.515736+00	104	32 100 ख. सोहि उमेर समूहका विद्यालय भर्ना भएका बालबालिकाको संख्या 175000	3		16	1
714	2022-06-01 08:17:40.516655+00	103	32 99 क. पालिका भित्रका विद्यालय जाने उमेर समूहका कुल बालबालिकाको संख्या 250000	3		16	1
715	2022-06-01 08:17:40.517451+00	102	32 102 घ. अपलोड फिल्ड test.json	3		16	1
716	2022-06-01 08:17:40.518245+00	101	28 85 ग. खर्च प्रतिशत 75	3		16	1
717	2022-06-01 08:17:40.519017+00	100	28 84 ख. कुल पूँजीगत बजेट खर्च रकम 250000	3		16	1
718	2022-06-01 08:17:40.519852+00	99	28 83 क. कुल विनियोजित पूँजीतगत बजेट रकम 450000	3		16	1
719	2022-06-01 08:17:40.520641+00	98	27 81 ग. खर्च प्रतिशत 75	3		16	1
720	2022-06-01 08:17:40.521426+00	97	27 80 ख. कुल खर्च भएको बजेट रकम 15000	3		16	1
721	2022-06-01 08:17:40.522211+00	96	27 79 क. कुल विनियोजित बजेट रकम 20000	3		16	1
722	2022-06-01 08:17:40.523104+00	95	27 82 घ. अपलोड फिल्ड पोर्टल निर्माण गर्दा सूचकको भर्नुपर्ने विवरण (1).docx	3		16	1
723	2022-06-01 08:17:40.523918+00	94	3 11 ग. जम्मा गरेको मिति 2078-07-25	3		16	1
724	2022-06-01 08:17:40.524702+00	93	3 129 घ. प्रतिशत 40	3		16	1
725	2022-06-01 08:17:40.525498+00	92	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 104000	3		16	1
726	2022-06-01 08:17:40.526284+00	91	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 260000	3		16	1
727	2022-06-01 08:17:40.527049+00	90	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
728	2022-06-01 08:17:40.527829+00	89	3 11 ग. जम्मा गरेको मिति 2078-07-21	3		16	1
729	2022-06-01 08:17:40.528639+00	88	3 129 घ. प्रतिशत 40	3		16	1
730	2022-06-01 08:17:40.52942+00	87	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 100000	3		16	1
731	2022-06-01 08:17:40.530208+00	86	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 250000	3		16	1
732	2022-06-01 08:17:40.531+00	85	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
733	2022-06-01 08:17:40.531784+00	84	3 11 ग. जम्मा गरेको मिति 2078-07-26	3		16	1
734	2022-06-01 08:17:40.532561+00	83	3 129 घ. प्रतिशत 40	3		16	1
779	2022-06-01 08:17:40.568545+00	31	2 6 क. आधार पालना गरी विनियोजन गरिएको सशर्त अनुदानको कुल रकम 150000	3		16	1
735	2022-06-01 08:17:40.533336+00	82	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 96000	3		16	1
736	2022-06-01 08:17:40.534159+00	81	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 240000	3		16	1
737	2022-06-01 08:17:40.534936+00	80	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
738	2022-06-01 08:17:40.535735+00	79	3 11 ग. जम्मा गरेको मिति 2078-07-04	3		16	1
739	2022-06-01 08:17:40.536534+00	78	3 129 घ. प्रतिशत 40	3		16	1
740	2022-06-01 08:17:40.537332+00	77	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 88000	3		16	1
741	2022-06-01 08:17:40.538247+00	76	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 220000	3		16	1
742	2022-06-01 08:17:40.539061+00	75	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
743	2022-06-01 08:17:40.539889+00	74	3 11 ग. जम्मा गरेको मिति 2078-07-12	3		16	1
744	2022-06-01 08:17:40.540688+00	73	3 129 घ. प्रतिशत 40	3		16	1
745	2022-06-01 08:17:40.541475+00	72	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 80000	3		16	1
746	2022-06-01 08:17:40.542297+00	71	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 200000	3		16	1
747	2022-06-01 08:17:40.543097+00	70	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
748	2022-06-01 08:17:40.543885+00	69	3 11 ग. जम्मा गरेको मिति 2078-07-16	3		16	1
749	2022-06-01 08:17:40.544678+00	68	3 129 घ. प्रतिशत 40	3		16	1
750	2022-06-01 08:17:40.545484+00	67	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 76000	3		16	1
751	2022-06-01 08:17:40.546273+00	66	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 190000	3		16	1
752	2022-06-01 08:17:40.547066+00	65	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
753	2022-06-01 08:17:40.547854+00	64	3 11 ग. जम्मा गरेको मिति 2078-07-17	3		16	1
754	2022-06-01 08:17:40.548644+00	63	3 129 घ. प्रतिशत 40	3		16	1
755	2022-06-01 08:17:40.549427+00	62	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 68000	3		16	1
756	2022-06-01 08:17:40.550214+00	61	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 170000	3		16	1
757	2022-06-01 08:17:40.551023+00	60	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
758	2022-06-01 08:17:40.551847+00	59	3 11 ग. जम्मा गरेको मिति 2078-07-25	3		16	1
759	2022-06-01 08:17:40.552635+00	58	3 129 घ. प्रतिशत 40	3		16	1
760	2022-06-01 08:17:40.553414+00	57	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 64000	3		16	1
761	2022-06-01 08:17:40.554207+00	56	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 160000	3		16	1
762	2022-06-01 08:17:40.554982+00	55	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
763	2022-06-01 08:17:40.555803+00	47	3 11 ग. जम्मा गरेको मिति 2078-07-26	3		16	1
764	2022-06-01 08:17:40.556579+00	46	3 129 घ. प्रतिशत 40	3		16	1
765	2022-06-01 08:17:40.557351+00	45	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 52000	3		16	1
766	2022-06-01 08:17:40.558144+00	44	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 130000	3		16	1
767	2022-06-01 08:17:40.558916+00	43	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
768	2022-06-01 08:17:40.559693+00	42	3 11 ग. जम्मा गरेको मिति 2078-07-24	3		16	1
769	2022-06-01 08:17:40.560525+00	41	3 129 घ. प्रतिशत 40	3		16	1
770	2022-06-01 08:17:40.561309+00	40	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 72000	3		16	1
771	2022-06-01 08:17:40.562112+00	39	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 180000	3		16	1
772	2022-06-01 08:17:40.562924+00	38	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
773	2022-06-01 08:17:40.563708+00	37	3 11 ग. जम्मा गरेको मिति 2078-07-29	3		16	1
774	2022-06-01 08:17:40.564493+00	36	3 129 घ. प्रतिशत 40	3		16	1
775	2022-06-01 08:17:40.565379+00	35	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 60000	3		16	1
776	2022-06-01 08:17:40.566169+00	34	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 150000	3		16	1
777	2022-06-01 08:17:40.56697+00	33	3 12 ङ. अपलोड फिल्ड filename.txt	3		16	1
780	2022-06-01 08:17:40.569324+00	30	2 8 ग. अपलोड फिल्ड widgets.txt	3		16	1
781	2022-06-01 08:17:40.57017+00	29	16 51 ख. असार १० गते पछि आय व्ययको अनुमान पेश गरेको True	3		16	1
782	2022-06-01 08:17:40.570973+00	28	16 50 क. असार १० गते भित्र आय व्ययको अनुमान पेश गरेको True	3		16	1
783	2022-06-01 08:17:40.571763+00	27	16 52 ग. अपलोड फिल्ड पोर्टल निर्माण गर्दा सूचकको भर्नुपर्ने विवरण (1).docx	3		16	1
784	2022-06-01 08:17:40.572548+00	26	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
785	2022-06-01 08:17:40.573327+00	25	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष 	3		16	1
786	2022-06-01 08:17:40.574143+00	24	29 87 क. लेखा परिक्षण भएको आर्थिक वर्ष २०७८/७९	3		16	1
787	2022-06-01 08:17:40.574954+00	23	29 90 घ. बेरुजु प्रतिशत 85	3		16	1
788	2022-06-01 08:17:40.575787+00	22	29 89 ग. कायम भएको बेरुजुको रकम 85000	3		16	1
789	2022-06-01 08:17:40.576583+00	21	29 88 ख. कुल लेखा परिक्षण गरिएको रकम 90000	3		16	1
790	2022-06-01 08:17:40.577376+00	20	29 91 ङ. अपलोड फिल्ड nepali_english_glossary.pdf	3		16	1
791	2022-06-01 08:17:40.578157+00	19	28 85 ग. खर्च प्रतिशत 90	3		16	1
792	2022-06-01 08:17:40.578967+00	18	28 84 ख. कुल पूँजीगत बजेट खर्च रकम 240000	3		16	1
793	2022-06-01 08:17:40.579775+00	17	28 83 क. कुल विनियोजित पूँजीतगत बजेट रकम 430000	3		16	1
794	2022-06-01 08:17:40.58058+00	16	27 81 ग. खर्च प्रतिशत 90	3		16	1
795	2022-06-01 08:17:40.581343+00	15	27 80 ख. कुल खर्च भएको बजेट रकम 450000	3		16	1
796	2022-06-01 08:17:40.58215+00	14	27 79 क. कुल विनियोजित बजेट रकम 500000	3		16	1
797	2022-06-01 08:17:40.582924+00	13	27 82 घ. अपलोड फिल्ड local_name.csv	3		16	1
798	2022-06-01 08:17:40.583729+00	12	3 11 ग. जम्मा गरेको मिति 2078-07-16	3		16	1
799	2022-06-01 08:17:40.584534+00	11	3 10 ख. यस महिनामा सङ्कलन भएको सवारी साधन कर रकमको ४० प्रतिशतले हुने रकम स्थानीय तहको सञ्चित कोषमा जम्मा गरेको रकम 50000	3		16	1
800	2022-06-01 08:17:40.585329+00	10	3 9 क. यस महिनामा सङ्कलन भएको सवारी साधन कर रकम 120000	3		16	1
801	2022-06-01 08:17:40.586128+00	9	3 12 ङ. अपलोड फिल्ड test.txt	3		16	1
802	2022-06-01 08:17:40.586907+00	8	25 77 ग. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकमको तुलनामा गत आर्थिक वर्षको राजस्व सङ्कलन रकममा भएको बृद्धि प्रतिशत 60	3		16	1
803	2022-06-01 08:17:40.587713+00	7	25 76 ख. गत आर्थिक वर्षको राजस्व सङ्कलन रकम 220000	3		16	1
804	2022-06-01 08:17:40.588552+00	6	25 75 क. गत वर्ष भन्दा अघिल्लो आर्थिक वर्षको राजस्व सङ्कलन रकम 250000	3		16	1
805	2022-06-01 08:17:40.589348+00	5	24 73 ग. प्रक्षेपित लक्ष्यमा राजस्व सङ्कलन प्रतिशत 60	3		16	1
806	2022-06-01 08:17:40.590125+00	4	24 72 ख. यथार्थ सङ्कलन भएको राजस्व 120000	3		16	1
807	2022-06-01 08:17:40.590919+00	3	24 71 क. राजस्व सङ्कलनको प्रक्षेपित लक्ष्य 200000	3		16	1
808	2022-06-01 08:17:40.591719+00	2	25 78 घ. अपलोड फिल्ड सुचकको काल्पनिक तथ्याङ्क.docx	3		16	1
809	2022-06-01 08:17:40.592538+00	1	24 74 घ. अपलोड फिल्ड पोर्टल निर्माण गर्दा सूचकको भर्नुपर्ने विवरण (1).pdf	3		16	1
810	2022-06-01 08:19:21.162543+00	767	Pradesh 8	3		11	1
811	2022-06-01 08:19:21.164419+00	768	Pradesh 9	3		11	1
812	2022-07-25 05:08:04.822294+00	1	admin@mail.com	2	[{"changed": {"fields": ["Is office head"]}}]	10	1
813	2022-10-20 09:58:54.489108+00	43	anu@yopmail.com	2	[{"changed": {"fields": ["Is first login"]}}]	10	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	contenttypes	contenttype
5	sessions	session
6	sites	site
7	user_mgmt	menu
8	user_mgmt	role
9	user_mgmt	menupermission
10	user_mgmt	user
11	user_mgmt	level
12	user_mgmt	department
13	user_mgmt	leveltype
14	user_mgmt	userpost
15	user_mgmt	district
16	core	answer
17	core	centralbody
18	core	fiscalyear
19	core	survey
20	core	question
21	core	provincebody
22	core	option
23	core	localbody
24	core	fillsurvey
25	core	answerdocument
26	core	surveycorrection
27	core	correctionactivitylog
28	core	complaint
29	core	notification
30	core	appraisalreviewrequest
31	axes	accessattempt
32	axes	accesslog
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-11-15 10:10:57.642971+00
2	contenttypes	0002_remove_content_type_name	2021-11-15 10:10:57.650052+00
3	auth	0001_initial	2021-11-15 10:10:57.674002+00
4	auth	0002_alter_permission_name_max_length	2021-11-15 10:10:57.679841+00
5	auth	0003_alter_user_email_max_length	2021-11-15 10:10:57.685641+00
6	auth	0004_alter_user_username_opts	2021-11-15 10:10:57.691055+00
7	auth	0005_alter_user_last_login_null	2021-11-15 10:10:57.697802+00
8	auth	0006_require_contenttypes_0002	2021-11-15 10:10:57.699741+00
9	auth	0007_alter_validators_add_error_messages	2021-11-15 10:10:57.706629+00
10	auth	0008_alter_user_username_max_length	2021-11-15 10:10:57.712329+00
11	auth	0009_alter_user_last_name_max_length	2021-11-15 10:10:57.717431+00
12	auth	0010_alter_group_name_max_length	2021-11-15 10:10:57.722819+00
13	auth	0011_update_proxy_permissions	2021-11-15 10:10:57.72788+00
14	auth	0012_alter_user_first_name_max_length	2021-11-15 10:10:57.733693+00
15	user_mgmt	0001_initial	2021-11-15 10:10:57.792757+00
16	admin	0001_initial	2021-11-15 10:10:57.810034+00
17	admin	0002_logentry_remove_auto_add	2021-11-15 10:10:57.819495+00
18	admin	0003_logentry_add_action_flag_choices	2021-11-15 10:10:57.829026+00
19	user_mgmt	0002_alter_field_email_on_user	2021-11-15 10:10:57.841463+00
20	user_mgmt	0003_alter_field_email	2021-11-15 10:10:57.858593+00
21	user_mgmt	0004_alter_option_change_for_numerator_and_such_field_other_minor_length_changes	2021-11-15 10:10:57.871438+00
22	user_mgmt	0005_auto_20210913_0742	2021-11-15 10:10:57.906167+00
23	user_mgmt	0006_auto_20210913_0754	2021-11-15 10:10:57.938424+00
24	user_mgmt	0007_auto_20210913_0757	2021-11-15 10:10:57.971723+00
25	user_mgmt	0008_auto_20210913_1011	2021-11-15 10:10:58.006596+00
26	user_mgmt	0009_user_full_name	2021-11-15 10:10:58.019093+00
27	user_mgmt	0010_alter_user_mobile_num	2021-11-15 10:10:58.039793+00
28	user_mgmt	0011_auto_20210915_0527	2021-11-15 10:10:58.131954+00
29	user_mgmt	0012_user_level	2021-11-15 10:10:58.148372+00
30	user_mgmt	0013_alter_menu_order_id	2021-11-15 10:10:58.16374+00
31	user_mgmt	0014_auto_20210916_0827	2021-11-15 10:10:58.187842+00
32	user_mgmt	0015_auto_20210916_1159	2021-11-15 10:10:58.201964+00
33	user_mgmt	0016_alter_user_level	2021-11-15 10:10:58.21507+00
34	user_mgmt	0017_alter_user_level	2021-11-15 10:10:58.22827+00
35	user_mgmt	0018_role_level	2021-11-15 10:10:58.243883+00
36	user_mgmt	0019_alter_role_name	2021-11-15 10:10:58.310339+00
37	user_mgmt	0020_alter_role_level	2021-11-15 10:10:58.323536+00
38	user_mgmt	0021_role_unique_level_roles	2021-11-15 10:10:58.334108+00
39	user_mgmt	0022_alter_user_level	2021-11-15 10:10:58.346924+00
40	user_mgmt	0023_alter_user_level_add_parent_level_field	2021-11-15 10:10:58.362679+00
41	user_mgmt	0024_remove_department_level	2021-11-15 10:10:58.378906+00
42	user_mgmt	0025_user_personal_email	2021-11-15 10:10:58.39309+00
43	user_mgmt	0026_auto_20210922_0503	2021-11-15 10:10:58.411585+00
44	user_mgmt	0027_auto_20210922_0925	2021-11-15 10:10:58.449961+00
45	user_mgmt	0028_update_level_model_add_code_district	2021-11-15 10:10:58.475036+00
46	core	0001_initial	2021-11-15 10:10:58.605649+00
47	core	0002_alter_survey_name	2021-11-15 10:10:58.612864+00
48	core	0003_question_is_created	2021-11-15 10:10:58.619523+00
49	core	0004_rename_is_created_question_is_options_created	2021-11-15 10:10:58.625888+00
50	core	0005_alter_option_change_for_numerator_and_such_field_other_minor_length_changes	2021-11-15 10:10:58.674972+00
51	core	0006_alter_option_fix_option_type_choices	2021-11-15 10:10:58.691017+00
52	core	0007_rename_is_options_created_question_has_options	2021-11-15 10:10:58.69791+00
53	core	0008_rename_has_options_question_is_options_created	2021-11-15 10:10:58.704592+00
54	core	0009_alter_question_is_options_created	2021-11-15 10:10:58.710963+00
55	core	0010_alter_option_field_type	2021-11-15 10:10:58.727247+00
56	core	0011_alter_question_model_remove_unique_constraint	2021-11-15 10:10:58.744832+00
57	core	0012_alter_answer_fill_survey_model	2021-11-15 10:10:58.856306+00
58	core	0013_alter_answer_fillsurvey_add_level_reln	2021-11-15 10:10:59.018852+00
59	core	0014_alter_answer_fillsurvey_remove_reln_with_local_province_level	2021-11-15 10:10:59.067449+00
60	core	0015_alter_option_add_sequence_id	2021-11-15 10:10:59.084588+00
61	core	0012_alter_answer_add_fiscal_year	2021-11-15 10:10:59.120346+00
62	core	0016_merge_20210921_0530	2021-11-15 10:10:59.121828+00
63	core	0016_auto_20210921_0525	2021-11-15 10:10:59.14956+00
64	core	0017_merge_20210921_0757	2021-11-15 10:10:59.15113+00
65	core	0018_alter_options_minor_change_in_field_type_label	2021-11-15 10:10:59.166905+00
66	core	0019_activitylog_surveycorrection	2021-11-15 10:10:59.199115+00
67	core	0020_surveycorrection_level_type	2021-11-15 10:10:59.223433+00
68	core	0021_auto_20210926_0653	2021-11-15 10:10:59.273225+00
69	core	0022_alter_surveycorrection_status	2021-11-15 10:10:59.293314+00
70	core	0023_auto_20210927_0444	2021-11-15 10:10:59.302759+00
71	core	0024_rename_user_level_type_activitylog_action_level_type	2021-11-15 10:10:59.306978+00
72	core	0025_activitylog_action_level	2021-11-15 10:10:59.310782+00
73	core	0026_alter_activitylog_options	2021-11-15 10:10:59.31425+00
74	core	0027_auto_20210928_1331	2021-11-15 10:10:59.320075+00
75	core	0028_auto_20210928_1342	2021-11-15 10:10:59.327434+00
76	core	0029_correctionactivitylog_option_id	2021-11-15 10:10:59.331826+00
77	core	0030_complaint	2021-11-15 10:10:59.357432+00
78	core	0031_complaint_user	2021-11-15 10:10:59.382128+00
79	core	0032_surveycorrection_month	2021-11-15 10:10:59.400658+00
80	core	0033_alter_surveycorrection_month	2021-11-15 10:10:59.420051+00
81	core	0034_notification	2021-11-15 10:10:59.449878+00
82	core	0035_notification_level	2021-11-15 10:10:59.475937+00
83	core	0036_notification_question	2021-11-15 10:10:59.501087+00
84	core	0037_remove_notification_fill_survey	2021-11-15 10:10:59.528532+00
85	core	0038_alter_notification_options	2021-11-15 10:10:59.548217+00
86	core	0039_notification_correction_checked	2021-11-15 10:10:59.64387+00
87	core	0040_alter_complaint_model_add_filefield	2021-11-15 10:10:59.661946+00
88	core	0041_update_month_name	2021-11-15 10:10:59.700557+00
89	core	0042_auto_20211005_1003	2021-11-15 10:10:59.7073+00
90	core	0043_add_model_appraisal_review_request	2021-11-15 10:10:59.739716+00
91	core	0044_alter_model_appraisal_review_request_add_fields	2021-11-15 10:10:59.80692+00
92	sessions	0001_initial	2021-11-15 10:10:59.813604+00
93	sites	0001_initial	2021-11-15 10:10:59.818842+00
94	sites	0002_alter_domain_unique	2021-11-15 10:10:59.824604+00
95	core	0045_alter_add_district_code_add_nepali_date_in_fy	2021-11-18 11:01:27.087775+00
96	core	0046_model_Update_FiscalYear_Options	2021-11-18 11:01:27.110071+00
97	user_mgmt	0029_alter_add_district_code_add_nepali_date_in_fy	2021-11-18 11:01:27.115088+00
98	axes	0001_initial	2021-12-30 06:01:53.042561+00
99	axes	0002_auto_20151217_2044	2021-12-30 06:01:53.086765+00
100	axes	0003_auto_20160322_0929	2021-12-30 06:01:53.115005+00
101	axes	0004_auto_20181024_1538	2021-12-30 06:01:53.143405+00
102	axes	0005_remove_accessattempt_trusted	2021-12-30 06:01:53.151816+00
103	axes	0006_remove_accesslog_trusted	2021-12-30 06:01:53.156957+00
104	axes	0007_alter_accessattempt_unique_together	2021-12-30 06:01:53.195664+00
105	core	0047_add_active_fy	2021-12-30 06:01:53.204059+00
106	user_mgmt	0030_add_is_office_head	2022-07-19 10:08:15.628815+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
7xmvypmhnxlm1jvsv48ppv774552ffxs	.eJxVi0EOwiAQRe_C2jQVZhhwaeI5yMCANIoLaVfGu9uaLnT533_vpQIvcw1Lz88wiTqpo1WHXxg53fJje76zXds87KwPl8bT_bwbf1nlXtfGAYCLQh5Fk_FM4LQurBERikdtHOZkDclYJOeRWMgawGgoOaYC6v0Bhekzww:1mplPF:gAe8_H3_mjOWc_p0-m7iIqtr1asDWOd8fOZc6fsAtpk	2021-12-08 06:05:21.297252+00
awnaxts53qaabcspxtk3u7tumo72qbw3	.eJxVi0sOwjAMBe-SNaqaxLFrlkicI7KTQCoIC9KuEHfnoy5g-ebNPEyUdalx7eUe52z2xpvdL1NJl3L7HN_Zzm0ZNtaHY5P5etiMv6xKr-8mi_JIE5BXIAWnwUEoFiGhjh6JJ7AMjjNLooSOEAFAvA_2VJTUPF9fyzMZ:1mmrfe:wEgN3CWXyAvnp8d_epMDIrQoCGOovD2vW2mKHhej08A	2021-11-30 06:10:18.544552+00
ha2xt91c647kcz3el6rcdenk363c0i5e	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mmZJa:d4MkJcDEhQp9FSr9WL673uRdTDM-9JR4dUCls9P1GKw	2021-11-29 10:34:18.668536+00
0ral7ghgx0jt50dmjji7hxfaj2kqe5cs	.eJxVi0sOwjAMBe-SNaqCGzsJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHsze7XyacL-X2Ob6zndsybKwPU-P5etyMv6xyr-8Goo5oPZETH70rWEaAQOAsRwkhi54iinJwGCAjEFlCCaTqvYB15vkCW9czJA:1mx1yX:Mu_12cBT1e2mLgeq0DrfpqDPDcroyEBnmkvvUMItCmI	2021-12-28 07:11:49.746643+00
5y9eaeitokurja5g7baj9h0nfn4m7uq7	.eJxVi0sOwjAMBe-SNaqCGzsJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHsze7XyacL-X2Ob6zndsybKwPU-P5etyMv6xyr-8Goo5oPZETH70rWEaAQOAsRwkhi54iinJwGCAjEFlCCaTqvYB15vkCW9czJA:1mxPNh:36Qj9E5OWNtudb_5Qus0PDKjYZAAcZ_GaO-KBI8cJoQ	2021-12-29 08:11:21.261897+00
0hzrhy4a05y0txa9itb9vlpe90rkwty0	.eJxVi0sOwjAMBe_iNarqRPmYJRLniOzEJRWEBWlXFXfnoy5g-ebNbJB4XWpauz7SXOAIGODwC4XzVe-f5zvbpS3DzvpwbjzfTrvxl1Xu9d0Ij-LJEWExyBh4zMGTKZ6tkRAnVIyOxboS1aFmFG-VSXgiMaIKzxeqUzUW:1mmtVP:8iDV4nJgD2LXa5WEDx7iUxN1S2HI4u_TxQanQwgF4Vk	2021-11-30 08:07:51.870103+00
811tcin7kjzjw8y5he5f1vny6nmncwqt	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mmv2P:5J3_fAHQZOKeCdT_b63A5IOeONO5f0WfJsHNN-HrwWo	2021-11-30 09:46:01.37235+00
f0g1ay02rwal0fpuaqas2ziv0om1xgus	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mmvCF:qU3n7Uev74WpVy31ZjMpEhldyskJgaBS_UKITDsInzA	2021-11-30 09:56:11.857362+00
lc65q6cl841utkldriqxanh3dfsqjxjs	.eJxVi0sOwjAMBe_iNarqRPmYJRLniOzEJRWEBWlXFXfnoy5g-ebNbJB4XWpauz7SXOAIGODwC4XzVe-f5zvbpS3DzvpwbjzfTrvxl1Xu9d0Ij-LJEWExyBh4zMGTKZ6tkRAnVIyOxboS1aFmFG-VSXgiMaIKzxeqUzUW:1mmgbQ:6c3chqu8uyX3eiV81BBpdWVAvyDlouLw3TqecP_5Kfw	2021-11-29 18:21:12.934662+00
mn9c1gyu8p3e2jr6d3mcgfm6urbyhxfj	.eJxVi0EOwiAUBe_C2jRAgS8uTTwHeR9QGsWFtCvj3aVNF7p882beImCZS1hafoUpiZNQozj8Qka85-f6bLPe6jzsrA2Xiulx3o2_rKCV3sDrRDEDMERXOBsdjFfsO1DkrPaGXZZgIi0VkpU2mUTM49H3QIrPF8B9NIg:1mmZXq:IXuzcmquQxvtKptifUJglw7e_fcJXO6ulC7nSLGddHI	2021-11-29 10:49:02.227702+00
c5hwmppi02kdls9mi93w0bftyw123bd0	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mmZeO:uZQssfr-1NKWadPc0Bh6z8ZGu2oEtGGYSHhEANWZEO4	2021-11-29 10:55:48.895804+00
ubsr3n36jdqfvptj16x5alzy5knooy2w	.eJxVi0EOwiAQRe_C2jQFBmbGpYnnIFCm0igupF0Z727bdKHL9_5_bxXiMpewNHmFKauz0qBOvzLF4S7Pbdmx3urcHa511xqnx-V4_GUltrI22ZlkgAxmlL5nT9aC1SQ8eHGAnK3zKAYTeU4aaExISBuJINOoPl96RTNV:1mmxYW:3qMK8y7IjUAF71xXirlAhELXoCDL32lWlSFM3-mIpAw	2021-11-30 12:27:20.147115+00
vxw3tg8a3hdjqnvch61abgo0bwimygm1	.eJxVizsOwjAQBe_iGkWxiddeSiTOYe3HwRGYAicV4u4kKAWUb97MyyRa5pKWlp9pUnMy3hx-GZPc8mM7vrNe69ztrHWXStP9vBt_WaFW1saC48DqCHxkZBQXEFm9FQo-QCQVtL24HljyESHawaO6UdRGonEw7w-JfjRo:1mmfwp:lEhUt5sN6M_SKjPeKU8YVxQbtBAmNLaffezPuIqLT6g	2021-11-29 17:39:15.572157+00
ss37ej2oeqtogl2yya78uqfzeggsj3tp	.eJxVi0EOAiEMRe_C2kxoSQl1aeI5SKEgE8WFzKyMd3c0s9Dlf_-9p4myLi2uozzirOZogMzhFybJ13L_PN_ZL32Zdjamc5f5dtqNv6zJaFuDNSgqIaMUQUkAzgb2DtAh2aDqqxebWIBEmQvZIhvSlDNkqmxeb6IENLA:1mmhJK:p-mSBD7dd2fcW5O2CyMhtGHmCmdap3i0B8QHMz6g_GU	2021-11-29 19:06:34.021731+00
5hbqcj0hze94qwmhioqqkqw8i9a2mrrn	.eJxVi0sOwjAMBe-SNaqaxLFrlkicI7KTQCoIC9KuEHfnoy5g-ebNPEyUdalx7eUe52z2xpvdL1NJl3L7HN_Zzm0ZNtaHY5P5etiMv6xKr-8mi_JIE5BXIAWnwUEoFiGhjh6JJ7AMjjNLooSOEAFAvA_2VJTUPF9fyzMZ:1mnBqm:-w_rWiexrDDhzAiqianQlls3a8sll6NwCNOMucciE1g	2021-12-01 03:43:08.317349+00
ivkhbv228zo2bikht0aj5bwyrckayhm6	.eJxVi0EOwiAQRe_C2jQFBmbGpYnnIFCm0igupF0Z727bdKHL9_5_bxXiMpewNHmFKauz0qBOvzLF4S7Pbdmx3urcHa511xqnx-V4_GUltrI22ZlkgAxmlL5nT9aC1SQ8eHGAnK3zKAYTeU4aaExISBuJINOoPl96RTNV:1mnD3F:J4FNngctY4lA5xTeYiP3iqx2idM3MWvknPxKG1jfdsI	2021-12-01 05:00:05.271918+00
88j6jlappuc7jq3z3ki3b2a5b2f9opl4	.eJxVi0sOwjAMBe_iNarqRPmYJRLniOzEJRWEBWlXFXfnoy5g-ebNbJB4XWpauz7SXOAIGODwC4XzVe-f5zvbpS3DzvpwbjzfTrvxl1Xu9d0Ij-LJEWExyBh4zMGTKZ6tkRAnVIyOxboS1aFmFG-VSXgiMaIKzxeqUzUW:1mnEFP:S9JdgQvGeyX-7a7ceQ30dRGUGVz6swLG1nguu_PxMKs	2021-12-01 06:16:43.132623+00
pqgisc8fu07umud9hpz6sddb5x4kbo2a	.eJxVi8sOwiAQRf-FtWmAGWBwadLvIEOnSKO4kHZl_Hcf6UKX99xzHirxtta09fmeFlFHZbQ6_MLM02W-fZ7vbOe2Djvrw9h4uZ524y-r3Ou7AbAgTiJ5k73zQROCRV04ElksJDoihyJMQRvMEQxnAWdKFvSxTOr5AnTuM6c:1mnupf:4oq1vf8yRm4GfcxoKNVTgFTWeqmOHcPyjBuQ5PqAL74	2021-12-03 03:44:59.63539+00
rpomc2h5ea1k5sy5d9tfmqzomwjqqm80	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mnvKQ:CNPYOxFNG89RePVX7i2BSJp-lhNxO7rz0DNx7ISebtg	2021-12-03 04:16:46.089823+00
aoq101sct4jiv8d864xc262dbegy1jdw	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mo1kH:pEygsFs-mEsZgz2hp8BKty4ACIUybpcI1TBXCdqPbV8	2021-12-03 11:07:53.8746+00
sywtv0b8y918nk521127it5yytgtepgx	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mp2Z2:qE0UUS1uEK-2z1Eyyg_FfJEh1xhBPNGLqYbSqcbuD9g	2021-12-06 06:12:28.754589+00
yxl5jt8zyhz9v6ty9fv30m7pn1wclom0	.eJxVi8sOwiAQRf-FtWmAGWBwadLvIEOnSKO4kHZl_Hcf6UKX99xzHirxtta09fmeFlFHZbQ6_MLM02W-fZ7vbOe2Djvrw9h4uZ524y-r3Ou7AbAgTiJ5k73zQROCRV04ElksJDoihyJMQRvMEQxnAWdKFvSxTOr5AnTuM6c:1mp3Gk:4jYbkZOKh-y2qNVhxdfc1fX5VVKwlEeF8j8DB-uY9sw	2021-12-06 06:57:38.050382+00
5kgej2iy18h4x7kva9360q4o6b9mk0ta	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mp5CR:n3MkvBvGduqMIB_YCqz6sg0os-eporBLJOJTuU7maI0	2021-12-06 09:01:19.171001+00
tm98t16brx357vjkgjeiukoq255nqo6p	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mp5Jg:u3gIfw3UUl6POHI02_LRkqQ1fq5wC2-6ibfDx8CXzcE	2021-12-06 09:08:48.878329+00
az885d0et39iklwj1utgsairwklp2oyx	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mpP9Z:3MSoV21VZzQwPlUTJZ7nh6celXK-7KslL-U3j9ISCTc	2021-12-07 06:19:41.878451+00
2nu01w4rnrorozqmigd1tubqjwm8i844	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mpTcs:0XIrZLttrYTxDt0RZoFzz65elXH1kxKV_r5MaugZi6c	2021-12-07 11:06:14.329638+00
n0hz7ao4axctkj373sonxlncvxoauk9a	.eJxVi0sOwjAMBe-SNaqCGzsJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHsze7XyacL-X2Ob6zndsybKwPU-P5etyMv6xyr-8Goo5oPZETH70rWEaAQOAsRwkhi54iinJwGCAjEFlCCaTqvYB15vkCW9czJA:1muopQ:IAnRvte9wdJ77hknR5zF9t-wQRjimUwCLme5XtZGq8k	2021-12-22 04:45:16.593485+00
0j1phd9tqxjveuepw8klbw5633gn1ej9	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nwQp1:MN97chxLGI3cA0T2bFIc_7sTkDjkMrFhoT4a685z_rM	2022-06-15 16:03:47.326329+00
w74pzikngthn9jcf7lx7wr1t68qzku78	.eJxVi8sOwiAQRf-FtWmmDBR0aeJ3kAsD0igupF0Z_91HutDlPfechwpYlxrWnu9hFnVQ2qjdL4xIl3z7PN_Zzm0ZNtaHU8N8PW7GX1bR67uBMFuhEr1kVzSsAJHsnvNkwKVAM2IWmnzi6MgZ1qMgGZo0-RGkni_aqzTy:1mwIoM:e9N4zf94yAa8RkIS_aKrkz_mg5dFaEobQiiUjceqWQY	2021-12-26 06:58:18.06089+00
cy5icwhudwis6dtexr4xkdblhqmtgcrs	e30:1mwcd5:iAVcYSuI6GjIg1L8Nzb_k13AXF-gDZ6jsnHsJ4MvhFU	2021-12-27 04:07:59.317469+00
eiy76pwf7k0n61a3g72x9z2ljstdlot4	.eJxVi0sOwjAMBe-SNaoSx04CSyTOEbmOQyooC9KuEHfnoy5g-ebNPEzmdWl57XrPUzEH45LZ_cKR5aK3z_Od83leho314TTzdD1uxl_WuLd3E2qyFgAKkWfxArFgQbWoRUiQwcboXQiuqiBWAqmj2n31MSYKnszzBZ-fM_w:1mpoa2:BVmxzY4UkIMcG8SCL5kY__Uy_4WD4qURceOvcE-fmTw	2021-12-08 09:28:42.101264+00
1x8hyj9x1vwgf7bhr8059iyonk9nq1gy	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1n2oVq:VgU5yITqgW90CgljE_k-H2iOI8r2IgQbuAqyMU4uuMA	2022-01-13 06:02:06.984487+00
tx3z88ahmd4yjwgq1ng77zhcqzopcss3	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1n2oYB:bKrX5T_IXajqpn1-XZaj3_Rbz6Zs1Kz_qVuWKA8HY7M	2022-01-13 06:04:31.805419+00
m4hzgw7cqth7dnsz9w6m37ruu2xxktbc	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nvY2l:yGEvsY_90JQD3mv-YAUrpM0sGoc1i9OSyrrLb0_NGPA	2022-06-13 05:34:19.38837+00
sbyd297gdx88p64joah823wxaw7u8kgz	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nXId4:o_2HNC7uf_drjVFkrj59JocuzZfAXybOsSoRqMKkvWs	2022-04-07 08:15:34.841923+00
go223jrfpe05t0o3nz96rfc0rvhkfsja	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1o8c9K:RzpcW2vrbsk_dn7xGw9asqk6wO0sNPEERFznaQ5tmXg	2022-07-19 06:35:06.992267+00
8clll0kxm401r9furz3ok9cwb119s08u	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nc14r:qSIf_M2i1X2ABqeGO1WdtbebivO7nsMqYMuuK17mWo0	2022-04-20 08:31:45.267214+00
e3p8bbkdfjmvrysplax90vt1oufnxovk	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nc2Ac:yIvrBbSC_wpawuaZb67zpom7SJf0rY6sq6_-nLyDbo8	2022-04-20 09:41:46.85869+00
01mrb2ypeerg8h2rqjde05629dudf32z	.eJxVjMEOwiAQRP-FsyEsIIJH7_0GsiyLVA1NSnsy_rtt0oNmbvPezFtEXJca185zHLO4CrDi9FsmpCe3neQHtvskaWrLPCa5K_KgXQ5T5tftcP8OKva6rTmxzUorawyfAaxxxWEG7zV5cBAoACjNjKEkTKSAoGyxF0vOo1Hi8wX4bDez:1o93c9:4JVn-sM1Eg2dnQImzbcUTHRHNyqIStYNRy1Njw42Kts	2022-07-20 11:54:41.502203+00
4x5rf5o3lxuxens55kpqep4576zy7x5w	.eJxVjMsOwiAQAP-FsyG8WlaP3vsNhGUXqZqSlPZk_Hcl6UGvM5N5iRD3rYS98RpmEhehvTj9QozpwUs3dI_LrcpUl22dUfZEHrbJqRI_r0f7Nyixlf51CTKMzmc0Gsh69E4pQJPMl3tjE0TgZJgpj3gecXCaBmRyiq0DFO8PAh04Rw:1nvbWB:QLli8kXQsyKPC42U1XbL_Iwh3mbcCnE5_U2mUcxuDX8	2022-06-13 09:16:55.080469+00
j905yut1wcuci1m7douc0abx381wdpvt	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1o9h8J:crrErZcscgfKB9tYpYLRJm3LswtYELTq998uRk0-mq8	2022-07-22 06:06:31.533051+00
q0i4vcr9fgymz37g8g7no6nrx6zblkwh	.eJxVjDsOwjAQBe_iGll2vPGHkj5nsHb9wQFkS3FSIe5OIqWAdmbeezOP21r81tPi58iuTDp2-YWE4ZnqYeID673x0Oq6zMSPhJ-286nF9Lqd7d9BwV72dQZhSVOWSqqsrRzRJUhjUCAd6CB2lm2iKIzSYOMgDFkAHISWpNAI9vkC-L03Rw:1ncfjx:hPELKgeFOVcC1930GrWoda1oSN3DENnXekXEc0dhgZA	2022-04-22 03:56:53.317331+00
v6na043fleeasyj90brjuczhs7unei04	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nclUh:qXDJMxMndyfBvUQz2TazfhxCUN-9HzJ_yMQ1G3OnMcM	2022-04-22 10:05:31.063877+00
i7h9e0c6knc0m1mh2vh2xowaabuhj3vu	.eJxVjEEOwiAQRe_C2pAOg5S6dN8zkBkYpGpoUtqV8e7apAvd_vfef6lA21rC1mQJU1IXhaBOvyNTfEjdSbpTvc06znVdJta7og_a9DgneV4P9--gUCvf2pLnOJAz1HEyYqPzCU2HhA4E7MBkxSXKgLkH7iOjB_DZsyCcbQb1_gAYDDhM:1ne7V3:rFz9VWPPXSS6M7uKtDQ1TpIT-q7w9ArkhHOQYcA7UXc	2022-04-26 03:47:29.315844+00
qpr7w824igc9rn8f6pe5beosfr89kj8x	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1oDfPw:doVPE5FfmSEKWQhHUu42IXYi1ga3lB8K-KjfEJ883uw	2022-08-02 05:05:08.490178+00
z0xmu7y5hc18bb8xda99f00hjsqneihd	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1oDgJC:7IU7GHBSIcnN03aJPgyjeI1z6JcSSo1OEcci2lz0UWk	2022-08-02 06:02:14.177792+00
6jl48qjkohauz38jt7wv460s9se6itow	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1oDkCM:k5j469kO3HB6wf7RTYREeIGjJJD2Ohz5CA2CsaaKSGg	2022-08-02 10:11:26.287815+00
i1o5xu466mb41789hbizbvy9a3tz7aw1	.eJxVjMEOwiAQRP-FsyELhQU9evcbyBYWqRpISnsy_rtt0oOeJpn3Zt4i0LqUsHaew5TERSgrTr_lSPHJdSfpQfXeZGx1madR7oo8aJe3lvh1Pdy_g0K9bOvs9ZnA5QQDoAePYHTMkc3ggJ2xKnuLmhEzKgcatrSgUGVL6Dyg-HwB2pw2Xw:1oFqEP:id9sj-2z8EGfILny00Sp7Ty8NJ5Z9dqtd77FQQBWaeI	2022-08-08 05:02:13.205013+00
nljdypzldd28fescd5h2xz3iplzpkl9c	.eJxVjMEOwiAQRP-FsyELhQU9evcbyBYWqRpISnsy_rtt0oOeJpn3Zt4i0LqUsHaew5TERSgrTr_lSPHJdSfpQfXeZGx1madR7oo8aJe3lvh1Pdy_g0K9bOvs9ZnA5QQDoAePYHTMkc3ggJ2xKnuLmhEzKgcatrSgUGVL6Dyg-HwB2pw2Xw:1oFqGr:Inavvr8n_Dm6dw8mMA006gl9HgpeavmJt_J6sj91dfw	2022-08-08 05:04:45.774205+00
l3fz2bo2kcb3whd0pjdbpid1bkpa4j77	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1oFqHt:hi8K9d5iCsEqIvccAstOz4XxNZNWJQfi5tGWNhmOQXY	2022-08-08 05:05:49.012248+00
b0bv4nbziqjzukgfseqjdhram5jgpr6j	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1oHMwX:xEd6INEZgyGWdd4Du9PnvCl8kBzsfNliQaVetbYUkyk	2022-08-12 10:10:05.086386+00
jp2g8nuokj7klrmx77vap8hy4gpfgpj2	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1olS7F:R-MK9QRGp72uqtJ0IQl6ADii0oBGNjxWeOy6vRM5ZnE	2022-11-03 09:45:29.855649+00
1dtudyxnctlovwjxtpj4n6pws9dqs65b	.eJxVi0sOwjAMBe-SNaqwmzgJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHA2b3y4Tzpdw-x3e2c1uGjfVhajxfj5vxl1Xu9d1kzxGpCBExgUcro9KIQuCyDYRiVSH4k1V0bgQkjnsVyCHEHBTRPF9usTNs:1mpjVH:nP5XDTJXN_vqYeilJRrBrWZ6NjgpW5DPn-FnsnXy04w	2021-12-08 04:03:27.513796+00
8vq8d9v0wzbq12s5zcwtbads38rqh7ti	.eJxVi0EOwiAQRe_C2jQVZhhwaeI5yMCANIoLaVfGu9uaLnT533_vpQIvcw1Lz88wiTqpo1WHXxg53fJje76zXds87KwPl8bT_bwbf1nlXtfGAYCLQh5Fk_FM4LQurBERikdtHOZkDclYJOeRWMgawGgoOaYC6v0Bhekzww:1mu7CX:MJgxpzL0rPvccMjd0pw8-YWq_crwtQqI0iFs9_QSD34	2021-12-20 06:10:13.806992+00
y1m64yhiakostfi4gdycv3vzuqw2vr5t	.eJxVizsOwjAQBe_iGkW78cYfSiTOYe36gyMwBU4qxN0JKAWUb97MUwVelxrWnh9hTuqo0KvDLxSO13z_PN_ZLm0ZdtaHc-P5dtqNv6xyr1tTCJwYKahRF-NwYp8pT1ETejIRNlZclgRWG3JpBCuOiEcwKJotqNcbm_Iznw:1mpmMR:Pw5qnWuJeAdLMNP2zOQq07aZlf-awR86N7n9sLPLQ3A	2021-12-08 07:06:31.389648+00
ccidljk8fscfq5pxcdz7a1yym8994jj7	.eJxVi0sOwjAMBe-SNaqCGzsJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHsze7XyacL-X2Ob6zndsybKwPU-P5etyMv6xyr-8Goo5oPZETH70rWEaAQOAsRwkhi54iinJwGCAjEFlCCaTqvYB15vkCW9czJA:1mvGtH:YAX3ipiftXdQkKy2fVMdqdnACUw8egGl_rHNoxA3f54	2021-12-23 10:43:07.365216+00
mrcji34ssu7vck696wlcj8t2trr4x1x6	.eJxVi0sOwjAMBe-SNaqCGzsJS6SeI7LjQCoIC9KuEHfnoy5g-ebNPEzidalp7eWeZjUHsze7XyacL-X2Ob6zndsybKwPU-P5etyMv6xyr-8Goo5oPZETH70rWEaAQOAsRwkhi54iinJwGCAjEFlCCaTqvYB15vkCW9czJA:1mwIZU:2UY54y0HSnumCy6_v1plq4Md5xjf_87K6woLp6sNO00	2021-12-26 06:42:56.531629+00
sgqnqtk5sy5htkjebwvdmxf95tcrok62	.eJxVi0sOwjAMBe_iNarqRPmYJRLniOzEJRWEBWlXFXfnoy5g-ebNbJB4XWpauz7SXOAIGODwC4XzVe-f5zvbpS3DzvpwbjzfTrvxl1Xu9d0Ij-LJEWExyBh4zMGTKZ6tkRAnVIyOxboS1aFmFG-VSXgiMaIKzxeqUzUW:1mwJOz:axo05O5LQO66h2M-dN7AaSHXFo-1lLuOCiO_10Tu6ww	2021-12-26 07:36:09.075246+00
cxp3e16on3lwrphqtynhlub944jah1yi	eyJfcGFzc3dvcmRfcmVzZXRfdG9rZW4iOiJheGx4bTUtYzZhMTNlYmJlMGQ2MDQ0ZjBjMmM4MmQ4M2NkMGU4MGUifQ:1mwkYV:RRu6MR0XIcdWD8OrVcU_B-KPN1dIGCi8_scF7uahvSY	2021-12-27 12:35:47.472516+00
5tdzyxfgsn9y55fixrz0iwijx2vy064h	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1n2oWn:rxFte3M4MuMz5XlYefZtkOBMQ8Y43Y8MAzozRsKANBE	2022-01-13 06:03:05.160814+00
p5uw6cy16hpkk8n8cy3xei4e9jtg58d6	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nwe2m:dRhi1h0AZ4A77mHMzJQJ82j2V0pd_B96p0aNuPT3Y88	2022-06-16 06:10:52.675081+00
rgszyx4en3jtkjrqwimnbnv4c42ae9zl	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nvYBl:bU_TA3Xw_HZJ-pEZ_qpQ6bzpE38PF0snqWmLFC0cj3w	2022-06-13 05:43:37.533621+00
3pi70dzh7eky8z46gwt1hymr99ey2yvy	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nDIU4:tdaRakK7P2ZIfETngxiE_HWLWqBInX9V3iePdQAhYBI	2022-02-11 04:03:36.553257+00
07rsv5rm8p26c06cakiu960n1h2pn960	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nwh4m:wSlQ2NQON5uYkaWrZHzRrtRpEnTmVtNzKf57O20AbT4	2022-06-16 09:25:08.746166+00
g04gafm82fyq5bjufkoeh97fghixrswd	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nXIdA:B55luVTQ4-n5i7RvXhTMa-chtoj4aDV7V1BKOa61MhA	2022-04-07 08:15:40.793799+00
7vuglv04q8gmf7wemet8mr5vevng5qx9	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nc14R:qBaUNXQXwZoCin5fDscP_z60NCP-do0HzINZBrOqS4Y	2022-04-20 08:31:19.22205+00
y9dxmbj0ixt54u28m7nqk6jfcs23hlt6	.eJxVjDsOwjAQBe_iGlnrNbZjSvqcIfJ-TAIokfKpEHeHSCmgfTPzXqYr29p326JzN4i5GJ_N6Xekwg8ddyL3Mt4my9O4zgPZXbEHXWw7iT6vh_t30Jel_9ZRnG8QKVQPIQMIJET0mlyiAMIUz-Cc48wxaIMOakChnIRZKyqZ9wfYdjeQ:1o93jI:FjWvsBx76N9dNCkwDfjwxrw3m5B792xuE5h3z4rnSDM	2022-07-20 12:02:04.371203+00
jfi701a2hbpmjg61u11qnexjlsshtwzp	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nc1rl:UUzORWHFZ5kRH-d2iH9gwiEk9DZgh4shofl2_eLIiSQ	2022-04-20 09:22:17.896884+00
1tci1hdhhuayuc3sehca4h9b819g174d	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nvdfr:P4SmODmkYHlmCjSF8y_K-5N3Rsm8sIHHJqu7KHgYxcY	2022-06-13 11:35:03.511455+00
a99vbo2ulr8bnax6ljwragv2r1ohhbrz	.eJxVjEEOwiAQRe_C2hCYgVJcuvcMhBmoVA0kpV0Z765NutDtf-_9lwhxW0vYel7CnMRZgBOn35EiP3LdSbrHemuSW12XmeSuyIN2eW0pPy-H-3dQYi_fWluTI2r2isENmeJgVSKLDpG8G40zRIAeAFmjn0ZUnMkpzcRMAJN4fwDyIjfB:1ncKC3:yY5RxB78U4U1zKmvYdhNl4obkgDEOWF6IAquK43DCSk	2022-04-21 04:56:27.850561+00
m5si28x2g7zikilwe1kurcqajqfc9cc1	.eJxVjEEOwiAQRe_C2pBCKQwu3XsGMjOAVA0kpV0Z765NutDtf-_9lwi4rSVsPS1hjuIsNIjT70jIj1R3Eu9Yb01yq-syk9wVedAury2m5-Vw_w4K9vKt8-AnsCM7z-zRMgIlQAZCHZ0BVIOOxjg0k0LOGcEA62RHyqNRipR4fwAiNDiV:1ncOmc:Weicm67waZRxCUorakCbZed90ts8f2Ct2dXMo8YKmI4	2022-04-21 09:50:30.803882+00
sblvxzbfqmgttoq8lc1gwg8aml2xcwd3	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nchNT:ss_-mA6Te0AFVLxu5kKQU-NSxcISt9IKvv_B_Op6OrU	2022-04-22 05:41:47.166711+00
otwsm7etuem1awbav2waw87y6v320bpz	.eJxVjEEOwiAQRe_C2hAYoAWX7j0DYWZAqoYmpV0Z765NutDtf-_9l4hpW2vcel7ixOIsjBKn3xETPXLbCd9Tu82S5rYuE8pdkQft8jpzfl4O9--gpl6_tdUMrLE4IlsMJPJgFAUExeiCBYM8WM7a-8Bq1OhKYgUaAnksZhzE-wMRpzgh:1nchip:ASCYC4n4M9r_hulZH00sPP9klqbpoXyUv6hrax329GU	2022-04-22 06:03:51.858592+00
7bb7xy3xmy6cmgth3ugyekj9dqne7yjy	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nvxJn:EMTtjWzp2_GF1lJeU2xugppmrGZa40IUlPrhgoH0wpw	2022-06-14 08:33:35.658162+00
3ygyb6gr01pzi8yv6bpesz5mj3m7m59w	.eJxVjDkOwjAUBe_iGlmxiZdPSZ8zWH9xcAA5UpxUiLtDpBTQvpl5L5VwW0vaWl7SJOqinDr9boT8yHUHcsd6mzXPdV0m0ruiD9r0MEt-Xg_376BgK9_aeEuBxKJ3kYCAbQAgcYYxuOAjCoPp2HaeOJ_BR9M7EDuymIg49ur9AeQ3OBA:1neUNM:MjNNrNJwFjKjemwzA2XN6Khh-efPMwDiCEqzIgSMVgc	2022-04-27 04:13:04.796059+00
ycreppz0o0nrboonotvc7wlty0xj7wfu	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1nwK0F:XgpyYHrIplUiYpyFYZ5plgCvjn5VAMXmXP5shQf_DIc	2022-06-15 08:46:55.591242+00
4zv2fb7plqgdarudu9ijp2vq6rnfxi4o	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1oFq9n:4QaGsfaREEDvYVM-4K-qxo1ueXcgqhx9pwDxJsMbpe4	2022-08-08 04:57:27.682856+00
xqd0747kgdchv4lk0setpz56f39sybm2	.eJxVjMEOwiAQRP-FsyELhQU9evcbyBYWqRpISnsy_rtt0oOeJpn3Zt4i0LqUsHaew5TERSgrTr_lSPHJdSfpQfXeZGx1madR7oo8aJe3lvh1Pdy_g0K9bOvs9ZnA5QQDoAePYHTMkc3ggJ2xKnuLmhEzKgcatrSgUGVL6Dyg-HwB2pw2Xw:1oFqD2:TNzfQ6VP2SRYx69QdgkUOlvkO__q2_W8m-i0EXWy-bE	2022-08-08 05:00:48.902982+00
5ohljb83ssb0g5zvhzwxmfr6iy4xd7kb	.eJxVjDkOwjAUBe_iGln-8ZZQ0nMG6y82CSBbylIh7g6RUkD7Zua9VMJtHdO25DlNos7KWXX6HQn5ketO5I711jS3us4T6V3RB130tUl-Xg7372DEZfzWMZO3pXdiw-ABDBkIHVg2LmRLDjACCvdUYiHDMpB4zixdV5DBUq_eH_9oOKk:1olSN6:cr7lFoD8vFF8fl-NzZwlO8juonUxrSRz5S9F-MRN1rw	2022-11-03 10:01:52.765864+00
l6m138b38dw1wpm0s6emdg83zx5bcz75	.eJxVjEEOwiAQRe_C2hCcwgAu3XuGZoZBqRpISrsy3l2bdKHb_977LzXSupRx7XkeJ1EndVSH340pPXLdgNyp3ppOrS7zxHpT9E67vjTJz_Pu_h0U6uVbQ5TBGY9o2Udvs8sDQECwhiKHkFiu0bFQsC5AcoBo0HFAEe8ZjFXvD7ZoNsw:1pa99r:dBKoyLifdIFcIoxqiXgoDA_Y6EOaFYEAuJyh6OGYafU	2023-03-23 05:49:43.835967+00
74e3g816p9rl4r2jubi3mgkhetgtg2vd	.eJxVjE0OwiAYRO_C2hBaaEGX7j0D-f6QqoGktCvj3W2TLnQ3mfdm3irCuuS4NpnjxOqi3KBOvyUCPaXshB9Q7lVTLcs8od4VfdCmb5XldT3cv4MMLW_rTpyIGQ2bQEKUpPeBO7aAYwoGUhewt0hieuHk7Bm27HEgxuTJgVWfL0RYOgQ:1qBCwS:fB1iUYWuyFComJYCf6KrZriJJyCN9SRsYmZaFl0Pp3U	2023-07-03 11:21:04.920301+00
\.


--
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.django_site (id, domain, name) FROM stdin;
1	192.168.50.45:1337	192.168.50.45:1337
\.


--
-- Data for Name: user_mgmt_department; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_department (id, created_at, updated_at, name, address, email) FROM stdin;
2	2021-11-15 11:18:35.744462+00	2021-11-19 06:59:19.140755+00	आर्थिक योजना तथा अर्थमन्त्रालय	गण्डकी प्रदेश, पाेखरा, नेपाल	ministry@info.com.np
3	2021-11-15 11:18:42.977377+00	2021-11-19 06:59:29.274484+00	प्रदेश उद्योग, पर्यटन, वन तथा वातावरण मन्त्रालय	गण्डकी प्रदेश, पाेखरा, नेपाल	pfcogandaki@gmail.com
1	2021-11-15 11:18:24.133392+00	2021-11-19 06:59:38.458003+00	मूख्यमन्त्री तथा मन्त्रीपरिषदको कार्यालय	गण्डकी प्रदेश, पाेखरा, नेपाल	finance_ministry@info.com.np
4	2021-11-15 11:18:50.063169+00	2021-11-19 07:00:47.503747+00	राष्ट्रिय प्राकृतिक स्रोत तथा वित्त आयोग	सिंहदरबार ,काठमाडौं, नेपाल	info@nnrfc.gov.np
5	2022-04-08 05:53:52.643951+00	2022-04-08 05:53:52.643974+00	DOIT	Kathmandu	doit@yopmail.com
\.


--
-- Data for Name: user_mgmt_district; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_district (id, name_eng, name_np, code) FROM stdin;
1	Taplejung	ताप्लेजुङ	\N
2	Sankhuwasabha	संखुवासभा	\N
3	Solukhumbu	सोलुखुम्बु	\N
4	Okhaldhunga	ओखलढुङ्गा	\N
5	Khotang	खोटाङ	\N
6	Bhojpur	भोजपुर	\N
7	Dhankuta	धनकुटा	\N
8	Terhathum	तेह्रथुम	\N
9	Panchthar	पाँचथर	\N
10	Ilam	इलाम	\N
11	Jhapa	झापा	\N
12	Morang	मोरङ	\N
13	Sunsari	सुनसरी	\N
14	Udayapur	उदयपुर	\N
15	Saptari	सप्तरी	\N
16	Siraha	सिरहा	\N
17	Dhanusa	धनुषा	\N
18	Mahottari	महोत्तरी	\N
19	Sarlahi	सर्लाही	\N
20	Rautahat	रौतहट	\N
21	Bara	बारा	\N
22	Parsa	पर्सा	\N
23	Dolakha	दोलखा	\N
24	Sindhupalchok	सिन्धुपाल्चोक	\N
25	Rasuwa	रसुवा	\N
26	Dhading	धादिङ	\N
27	Nuwakot	नुवाकोट	\N
28	Kathmandu	काठमाडौँ	\N
29	Bhaktapur	भक्तपुर	\N
30	Lalitpur	ललितपुर	\N
31	Kavrepalanchok	काभ्रेपलाञ्चोक	\N
32	Ramechhap	रामेछाप	\N
33	Sindhuli	सिन्धुली	\N
34	Makwanpur	मकवानपुर	\N
35	Chitwan	चितवन	\N
36	Gorkha	गोरखा	\N
37	Manang	मनाङ	\N
38	Mustang	मुस्ताङ	\N
39	Myagdi	म्याग्दी	\N
40	Kaski	कास्की	\N
41	Lamjung	लमजुङ	\N
42	Tanahu	तनहुँ	\N
43	Nawalparasi(बर्दघाट सुस्ता पूर्व)	नवलपरासी (बर्दघाट सुस्ता पूर्व)	\N
44	Syangja	स्याङ्जा	\N
45	Parbat	पर्वत	\N
46	Baglung	बाग्लुङ	\N
47	Rukum	रुकुम (पूर्वी भाग)	\N
48	Rolpa	रोल्पा	\N
49	Pyuthan	प्यूठान	\N
50	Gulmi	गुल्मी	\N
51	Arghakhanchi	अर्घाखाँची	\N
52	Palpa	पाल्पा	\N
53	Nawalparasi	नवलपरासी	\N
54	Rupandehi	रूपन्देही	\N
55	Kapilvastu	कपिलवस्तु	\N
56	Dang	दाङ	\N
57	Banke	बाँके	\N
58	Bardiya	बर्दिया	\N
59	Dolpa	डोल्पा	\N
60	Mugu	मुगु	\N
61	Humla	हुम्ला	\N
62	Jumla	जुम्ला	\N
63	Kalikot	कालिकोट	\N
64	Dailekh	दैलेख	\N
65	Jajarkot	जाजरकोट	\N
66	Rukum(पश्चिम भाग)	रुकुम (पश्चिम भाग)	\N
67	Salyan	सल्यान	\N
68	Surkhet	सुर्खेत	\N
69	Bajura	बाजुरा	\N
70	Darchula	दार्चुला	\N
71	Baitadi	बैतडी	\N
72	Dadeldhura	डँडेलधुरा	\N
73	Doti	डोटी	\N
74	Achham	अछाम	\N
75	Kailali	कैलाली	\N
76	Kanchanpur	कञ्चनपुर	\N
77	Bajhang	बझाङ	\N
\.


--
-- Data for Name: user_mgmt_level; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_level (id, name, type_id, province_level_id, level_code, district_id) FROM stdin;
13	ककनी गाउँपालिका	2	3	30512	27
14	अग्मीसयर कृष्ण सवरन गाउँपालिका	2	2	20103	15
15	गल्छी गाउँपालिका	2	3	30411	26
16	फक्ताङ्लुङ्ग गाउँपालिका	2	1	10101	1
17	राप्ती नगरपालिका	2	3	31301	35
18	आरुघाट गाउँपालिका	2	4	40105	36
19	गैडाकोट नगरपालिका	2	4	40801	43
20	सिस्ने गाउँपालिका	2	5	50102	47
21	तिनाउ गाउँपालिका	2	5	50607	52
22	काइके गाउँपालिका	2	6	60107	59
23	बीरेन्द्रनगर नगरपालिका	2	6	61006	68
24	पाटन नगरपालिका	2	7	70409	71
1	प्रदेश सरकार, १ नं. प्रदेश	1	\N	\N	\N
3	प्रदेश सरकार, बागमती प्रदेश	1	\N	\N	\N
46	माप्य दुधकोशी गाउँपालिका	2	1	10304	3
5	प्रदेश सरकार, लुम्बिनी प्रदेश	1	\N	\N	\N
4	प्रदेश सरकार, गण्डकी प्रदेश	1	\N	\N	\N
6	प्रदेश सरकार, कर्णाली प्रदेश	1	\N	\N	\N
7	प्रदेश सरकार, सुदूर पश्चिम प्रदेश	1	\N	\N	\N
25	मिक्वाखोला गाउँपालिका	2	1	10102	1
26	मेरिङ्गदेन गाउँपालिका	2	1	10103	1
27	मैवाखोला गाउँपालिका	2	1	10104	1
28	आठराई त्रिवेणी गाउँपालिका	2	1	10105	1
29	फुङलिङ्ग नगरपालिका	2	1	10106	1
30	पाथिभरा याङ्वराक गाउँपालिका	2	1	10107	1
31	सिरीजङ्गा गाउँपालिका	2	1	10108	1
32	सिदिङ्गवा गाउँपालिका	2	1	10109	1
33	भोटखोला गाउँपालिका	2	1	10201	2
34	मकालु गाउँपालिका	2	1	10202	2
35	सिलीचोङ गाउँपालिका	2	1	10203	2
36	चिचिला गाउँपालिका	2	1	10204	2
37	सभापोखरी गाउँपालिका	2	1	10205	2
38	खाँदबारी नगरपालिका	2	1	10206	2
39	पाँचखपन नगरपालिका	2	1	10207	2
40	चैनपुर नगरपालिका	2	1	10208	2
41	मादी नगरपालिका	2	1	10209	2
42	धर्मदेवी नगरपालिका	2	1	10210	2
43	खुम्बु पासाङल्हामु गाउँपालिका	2	1	10301	3
44	माहाकुलुङ गाउँपालिका	2	1	10302	3
45	सोताङ गाउँपालिका	2	1	10303	3
47	थुलुङ दुधकोशी गाउँपालिका	2	1	10305	3
48	नेचासल्यान गाउँपालिका	2	1	10306	3
49	सोलुदुधकुण्ड नगरपालिका	2	1	10307	3
50	लिखु पिके गाउँपालिका	2	1	10308	3
51	चिशंखुगढी गाउँपालिका	2	1	10401	4
52	सिद्धिचरण नगरपालिका	2	1	10402	4
53	मोलुङ्ग गाउँपालिका	2	1	10403	4
54	खिजीदेम्बा गाउँपालिका	2	1	10404	4
55	लिखु गाउँपालिका	2	1	10405	4
56	चम्पादेवी गाउँपालिका	2	1	10406	4
57	सुनकोशी गाउँपालिका	2	1	10407	4
58	मानेभन्ज्याङ्ग गाउँपालिका	2	1	10408	4
59	केपिलासगढी गाउँपालिका	2	1	10501	5
60	ऐसेलुखर्क गाउँपालिका	2	1	10502	5
61	रावा बेसी गाउँपालिका	2	1	10503	5
62	हलेसी तुवाचुङ नगरपालिका	2	1	10504	5
63	दिक्तेल रुपाकोट मझुवागढी नगरपालिका	2	1	10505	5
64	साकेला गाउँपालिका	2	1	10506	5
65	दिप्रुङ चुइचुम्मा गाउँपालिका	2	1	10507	5
9	Local Level 2	2	4	101	2
11	Local Level4	2	5	104	5
12	Local Level5	2	7	105	10
66	खोटेहाङ गाउँपालिका	2	1	10508	5
67	जन्तेढुङ्गा गाउँपालिका	2	1	10509	5
68	बराहपोखरी गाउँपालिका	2	1	10510	5
69	षडानन्द नगरपालिका	2	1	10601	6
70	साल्पासिलिछो गाउँपालिका	2	1	10602	6
71	टेम्केमैयुङ गाउँपालिका	2	1	10603	6
72	भोजपुर नगरपालिका	2	1	10604	6
73	अरुण गाउँपालिका	2	1	10605	6
74	पौवा दुङ्मा गाउँपालिका	2	1	10606	6
75	रामप्रसाद राई गाउँपालिका	2	1	10607	6
76	हतुवागढी गाउँपालिका	2	1	10608	6
77	आमचोक गाउँपालिका	2	1	10609	6
78	महालक्ष्मी नगरपालिका	2	1	10701	7
79	पाख्रिबास नगरपालिका	2	1	10702	7
80	छथर जोरपाटी गाउँपालिका	2	1	10703	7
81	धनकुटा नगरपालिका	2	1	10704	7
82	सहिदभूमि गाउँपालिका	2	1	10705	7
83	साँगुरीगढी गाउँपालिका	2	1	10706	7
84	चौविसे गाउँपालिका	2	1	10707	7
85	आठराई गाउँपालिका	2	1	10801	8
86	फेदाप गाउँपालिका	2	1	10802	8
87	मेन्छयायेम गाउँपालिका	2	1	10803	8
88	म्याङ्गलुङ्ग नगरपालिका	2	1	10804	8
89	लालीगुराँस नगरपालिका	2	1	10805	8
90	छथर गाउँपालिका	2	1	10806	8
91	याङवरक गाउँपालिका	2	1	10901	9
92	हिलिहाङ्ग गाउँपालिका	2	1	10902	9
93	फालेलुङ्ग गाउँपालिका	2	1	10903	9
94	फिदिम नगरपालिका	2	1	10904	9
95	फाल्गुनन्द गाउँपालिका	2	1	10905	9
96	कुम्मायक गाउँपालिका	2	1	10906	9
97	तुम्बेवा गाउँपालिका	2	1	10907	9
98	मिक्लाजुङ गाउँपालिका	2	1	10908	9
99	माई जोगमाई गाउँपालिका	2	1	11001	10
100	सन्दकपुर गाउँपालिका	2	1	11002	10
101	इलाम नगरपालिका	2	1	11003	10
102	देउमाई नगरपालिका	2	1	11004	10
103	फाकफोकथुम गाउँपालिका	2	1	11005	10
104	माङसेबुङ गाउापालिका	2	1	11006	10
105	चुलाचुली गाउँपालिका	2	1	11007	10
106	माई नगरपालिका	2	1	11008	10
107	सूर्योदय नगरपालिका	2	1	11009	10
108	रोङ गाउँपालिका	2	1	11010	10
109	मेचीनगर नगरपालिका	2	1	11101	11
110	बुद्धशान्ति गाउँपालिका	2	1	11102	11
111	अर्जुनधारा नगरपालिका	2	1	11103	11
112	कन्काई नगरपालिका	2	1	11104	11
113	शिवसताक्षी नगरपालिका	2	1	11105	11
114	कमल गाउँपालिका	2	1	11106	11
115	दमक नगरपालिका	2	1	11107	11
116	गौरादह नगरपालिका	2	1	11108	11
117	गौरीगन्‍ज गाउँपालिका	2	1	11109	11
118	झापा गाउँपालिका	2	1	11110	11
119	बाह्रदशी गाउँपालिका	2	1	11111	11
120	बिर्तामोड नगरपालिका	2	1	11112	11
121	हल्दीबारी गाउँपालिका	2	1	11113	11
122	भद्रमपुर नगरपालिका	2	1	11114	11
123	कचनकवल गाउँपालिका	2	1	11115	11
124	मिक्लाजुङ्ग गाउँपालिका	2	1	11201	12
125	लेटाङ नगरपालिका	2	1	11202	12
126	केराबारी गाउँपालिका	2	1	11203	12
127	सुन्दरहरैंचा नगरपालिका	2	1	11204	12
128	बेलबारी नगरपालिका	2	1	11205	12
129	कानेपोखरी गाउँपालिका	2	1	11206	12
130	पथरी शनिश्चरे नगरपालिका	2	1	11207	12
131	उर्लाबारी नगरपालिका	2	1	11208	12
132	रतुवामाई नगरपालिका	2	1	11209	12
133	सुनवर्षी नगरपालिका	2	1	11210	12
134	रंगेली नगरपालिका	2	1	11211	12
135	ग्रामथान गाउँपालिका	2	1	11212	12
136	बुढीगंगा गाउँपालिका	2	1	11213	12
137	विराटनगर महानगरपालिका	2	1	11214	12
138	कटहरी गाउँपालिका	2	1	11215	12
139	धनपालथान गाउँपालिका	2	1	11216	12
140	जहदा गाउँपालिका	2	1	11217	12
141	धरान उपमहानगरपालिका	2	1	11301	13
142	बराहक्षेत्र नगरपालिका	2	1	11302	13
143	कोशी गाउँपालिका	2	1	11303	13
144	भोक्राहा नरसिंह गाउँपालिका	2	1	11304	13
145	रामधुनी नगरपालिका	2	1	11305	13
146	इटहरी उपमहानगरपालिका	2	1	11306	13
147	दुहबी नगरपालिका	2	1	11307	13
148	गढी गाउँपालिका	2	1	11308	13
149	इनरुवा नगरपालिका	2	1	11309	13
150	हरिनगर गाउँपालिका	2	1	11310	13
151	देवानगन्ज गाउँपालिका	2	1	11311	13
152	बर्जु गाउँपालिका	2	1	11312	13
153	बेलका नगरपालिका	2	1	11401	14
154	चौदण्डीगढी नगरपालिका	2	1	11402	14
155	त्रियुगा नगरपालिका	2	1	11403	14
156	रौतामाई गाउँपालिका	2	1	11404	14
157	लिम्चुङ्बुङ गाउँपालिका	2	1	11405	14
158	ताप्ली गाउँपालिका	2	1	11406	14
159	कटारी नगरपालिका	2	1	11407	14
160	उदयपुरगढी गाउँपालिका	2	1	11408	14
161	सप्तकोशी नगरपालिका	2	2	20101	15
162	कन्चनरुप नगरपालिका	2	2	20102	15
163	रुपनी गाउँपालिका	2	2	20104	15
164	शम्भुनाथ नगरपालिका	2	2	20105	15
165	खडक नगरपालिका	2	2	20106	15
166	सुरुङ्गा नगरपालिका	2	2	20107	15
167	बलान बिहुल गाउँपालिका	2	2	20108	15
168	बोदेबरसाईन नगरपालिका	2	2	20109	15
169	डाक्नेश्वरी नगरपालिका	2	2	20110	15
170	राजगढ गाउँपालिका	2	2	20111	15
171	विष्णुपुर गाउँपालिका	2	2	20112	15
172	राजविराज नगरपालिका	2	2	20113	15
173	महादेवा गाउँपालिका	2	2	20114	15
174	तिरहुत गाउँपालिका	2	2	20115	15
175	हनुमाननगर कङ्कालिनी नगरपालिका	2	2	20116	15
176	तिलाठी कोइलाडी गाउँपालिका	2	2	20117	15
177	छिन्नमस्ता गाउँपालिका	2	2	20118	15
178	लहान नगरपालिका	2	2	20201	16
179	धनगढीमाई नगरपालिका	2	2	20202	16
180	गोलबजार नगरपालिका	2	2	20203	16
181	मिर्चेया नगरपालिका	2	2	20204	16
182	कर्जन्हा नगरपालिका	2	2	20205	16
183	कल्याणपुर नगरपालिका	2	2	20206	16
184	नरहा गाउँपालिका	2	2	20207	16
185	विष्णुपुर गाउँपालिका	2	2	20208	16
186	अर्नमा गाउँपालिका	2	2	20209	16
187	सुखीपुर नगरपालिका	2	2	20210	16
188	लक्ष्मीपुर पतारी गाउँपालिका	2	2	20211	16
189	सखुवानान्कारकट्टी गाउँपालिका	2	2	20212	16
190	भगवानपुर गाउँपालिका	2	2	20213	16
191	नवराजपुर गाउँपालिका	2	2	20214	16
192	बरियारपट्टी गाउँपालिका	2	2	20215	16
193	औरही गाउँपालिका	2	2	20216	16
194	सिराहा नगरपालिका	2	2	20217	16
195	गणेशमान चारनाथ नगरपालिका	2	2	20301	17
196	धनुषाधाम नगरपालिका	2	2	20302	17
197	मिथिला नगरपालिका	2	2	20303	17
198	बटेश्वर गाउँपालिका	2	2	20304	17
199	क्षिरेश्वरनाथ नगरपालिका	2	2	20305	17
200	लक्ष्मीनिया गाउँपालिका	2	2	20306	17
201	मिथिला बिहारी नगरपालिका	2	2	20307	17
202	हंसपुर नगरपालिका	2	2	20308	17
203	सबैला नगरपालिका	2	2	20309	17
204	शहीदनगर नगरपालिका	2	2	20310	17
205	कमला नगरपालिका	2	2	20311	17
206	जनक नन्दिनी गाउँपालिका	2	2	20312	17
207	बिदेह नगरपालिका	2	2	20313	17
208	औरही गाउँपालिका	2	2	20314	17
209	जनकपुरधाम उपमहानगरपालिका	2	2	20315	17
210	धनौजी गाउँपालिका	2	2	20316	17
211	नगराइन नगरपालिका	2	2	20317	17
212	मुखियापट्टी मुसहरमिया गाउँपालिका	2	2	20318	17
213	बर्दिबास नगरपालिका	2	2	20401	18
214	गौशाला नगरपालिका	2	2	20402	18
215	सोनमा गाउँपालिका	2	2	20403	18
216	औरही नगरपालिका	2	2	20404	18
217	भँगाहा नगरपालिका	2	2	20405	18
218	लोहरपट्टी नगरपालिका	2	2	20406	18
219	बलवा नगरपालिका	2	2	20407	18
220	राम गोपालपुर नगरपालिका	2	2	20408	18
221	साम्सी गाउँपालिका	2	2	20409	18
222	मनरा शिसवा नगरपालिका	2	2	20410	18
223	एकडारा गाउँपालिका	2	2	20411	18
224	महोत्तरी गाउँपालिका	2	2	20412	18
225	पिपरा गाउँपालिका	2	2	20413	18
226	मटिहानी नगरपालिका	2	2	20414	18
227	जलेश्वर नगरपालिका	2	2	20415	18
228	लालबन्दी नगरपालिका	2	2	20501	19
229	हरिवन नगरपालिका	2	2	20502	19
230	बागमती नगरपालिका	2	2	20503	19
231	बरहथवा नगरपालिका	2	2	20504	19
232	हरिपुर नगरपालिका	2	2	20505	19
233	ईश्वरपुर नगरपालिका	2	2	20506	19
234	हरिपुर्वा नगरपालिका	2	2	20507	19
235	पर्सा गाउँपालिका	2	2	20508	19
236	ब्रह्मपुरी गाउँपालिका	2	2	20509	19
237	चन्द्रनगर गाउँपालिका	2	2	20510	19
238	कविलासी नगरपालिका	2	2	20511	19
239	चक्रघट्टा गाउँपालिका	2	2	20512	19
240	बसबरिया गाउँपालिका	2	2	20513	19
241	धनकौल गाउँपालिका	2	2	20514	19
242	रामनगर गाउँपालिका	2	2	20515	19
243	बलरा नगरपालिका	2	2	20516	19
244	गोडैटा नगरपालिका	2	2	20517	19
245	विष्णु गाउँपालिका	2	2	20518	19
246	कौडेना गाउँपालिका	2	2	20519	19
247	मलंगवा नगरपालिका	2	2	20520	19
248	चन्द्रपुर नगरपालिका	2	2	20601	20
249	गुजरा नगरपालिका	2	2	20602	20
250	फतुवा बिजयपुर नगरपालिका	2	2	20603	20
251	कटहरिया नगरपालिका	2	2	20604	20
252	वृन्दावन नगरपालिका	2	2	20605	20
253	गढीमाई नगरपालिका	2	2	20606	20
254	माधव नारायण नगरपालिका	2	2	20607	20
255	गरुडा नगरपालिका	2	2	20608	20
256	देवाही गोनाही नगरपालिका	2	2	20609	20
257	मौलापुर नगरपालिका	2	2	20610	20
258	बौधीमाई नगरपालिका	2	2	20611	20
259	परोहा नगरपालिका	2	2	20612	20
260	राजपुर नगरपालिका	2	2	20613	20
261	यमुनामाई गाउँपालिका	2	2	20614	20
262	दुर्गा भगवती गाउँपालिका	2	2	20615	20
263	राजदेवी नगरपालिका	2	2	20616	20
264	गौर नगरपालिका	2	2	20617	20
265	ईशनाथ नगरपालिका	2	2	20618	20
266	निजगढ नगरपालिका	2	2	20701	21
267	कोल्हवी नगरपालिका	2	2	20702	21
268	जीतपुर सिमरा उपमहानगरपालिका	2	2	20703	21
269	परवानीपुर गाउँपालिका	2	2	20704	21
270	प्रसौनी गाउँपालिका	2	2	20705	21
271	विश्रामपुर गाउँपालिका	2	2	20706	21
272	फेटा गाउँपालिका	2	2	20707	21
273	कलैया उपमहानगरपालिका	2	2	20708	21
274	करैयामाई गाउँपालिका	2	2	20709	21
275	बारागढी गाउँपालिका	2	2	20710	21
276	आदर्श कोटवाल गाउँपालिका	2	2	20711	21
277	सिम्रौनगढ नगरपालिका	2	2	20712	21
278	पचरौता नगरपालिका	2	2	20713	21
279	महागढीमाई नगरपालिका	2	2	20714	21
280	देवताल गाउँपालिका	2	2	20715	21
281	सुवर्ण गाउँपालिका	2	2	20716	21
282	ठोरी (सुवर्णपुर) गाउँपालिका	2	2	20801	22
283	जिराभवानी गाउँपालिका	2	2	20802	22
284	जगरनाथपुर गाउँपालिका	2	2	20803	22
285	पटेर्वा सुगौली गाउँपालिका	2	2	20804	22
286	सखुवा प्रसौनी गाउँपालिका	2	2	20805	22
287	पर्सागढी नगरपालिका	2	2	20806	22
288	बिरगन्ज महानगरपालिका	2	2	20807	22
289	बहुदरमाई नगरपालिका	2	2	20808	22
290	पोखरिया नगरपालिका	2	2	20809	22
291	कालिकामाई गाउँपालिका	2	2	20810	22
292	धोबीनी गाउँपालिका	2	2	20811	22
293	छिपहरमाई गाउँपालिका	2	2	20812	22
294	पकाहा मैनपुर गाउँपालिका	2	2	20813	22
295	बिन्दबासिनी गाउँपालिका	2	2	20814	22
296	गौरीशंकर गाउँपालिका	2	3	30101	23
297	बिगु गाउँपालिका	2	3	30102	23
298	कालिन्चोक गाउँपालिका	2	3	30103	23
299	वैतेश्वर गाउँपालिका	2	3	30104	23
300	जिरी नगरपालिका	2	3	30105	23
301	तामाकोशी गाउँपालिका	2	3	30106	23
302	मेलुङ्ग गाउँपालिका	2	3	30107	23
303	शैलुङ गाउँपालिका	2	3	30108	23
304	भिमेश्वर नगरपालिका	2	3	30109	23
305	भोटेकोशी गाउँपालिका	2	3	30201	24
306	जुगल गाउँपालिका	2	3	30202	24
307	पाँचपोखरी थाङपाल गाउँपालिका	2	3	30203	24
308	हेलम्बु गाउँपालिका	2	3	30204	24
309	मेलम्ची नगरपालिका	2	3	30205	24
310	ईन्द्रावती गाउँपालिका	2	3	30206	24
311	चौतारा साँगाचोकगढी नगरपालिका	2	3	30207	24
312	बलेफी गाउँपालिका	2	3	30208	24
313	बाह्रबिसे नगरपालिका	2	3	30209	24
314	त्रिपूरासुन्दरी गाउँपालिका	2	3	30210	24
315	लिसंखु पाखर गाउँपालिका	2	3	30211	24
316	सुनकोशी गाउँपालिका	2	3	30212	24
317	गोसाइकुण्ड गाउँपालिका	2	3	30301	25
318	आमाछोदिङमो गाउँपालिका	2	3	30302	25
319	उत्तरगया गाउँपालिका	2	3	30303	25
320	कालिका गाउँपालिका	2	3	30304	25
321	नौकुण्ड गाउँपालिका	2	3	30305	25
322	रुबी भ्याली गाउँपालिका	2	3	30401	26
323	खनियाबास गाउँपालिका	2	3	30402	26
324	गंङ्गा जमुना गाउँपालिका	2	3	30403	26
325	त्रिपूरासुन्दरी गाउँपालिका	2	3	30404	26
326	नेत्रावती डबजोङ गाउँपालिका	2	3	30405	26
327	नीलकण्ठ नगरपालिका	2	3	30406	26
328	ज्वालामुखी गाउँपालिका	2	3	30407	26
329	सिद्धलेक गाउँपालिका	2	3	30408	26
330	बेनीघाट रोराङ्ग गाउँपालिका	2	3	30409	26
331	गजुरी गाउँपालिका	2	3	30410	26
332	थाक्रे गाउँपालिका	2	3	30412	26
333	धुनीबेंशी नगरपालिका	2	3	30413	26
334	दुप्चेश्वर गाउँपालिका	2	3	30501	27
335	तादी गाउँपालिका	2	3	30502	27
336	सूर्यगढी गाउँपालिका	2	3	30503	27
337	विदुर नगरपालिका	2	3	30504	27
338	किस्पाङ्ग गाउँपालिका	2	3	30505	27
339	म्यगङ गाउँपालिका	2	3	30506	27
340	तारकेश्वर गाउँपालिका	2	3	30507	27
341	बेलकोटगढी नगरपालिका	2	3	30508	27
342	लिखु गाउँपालिका	2	3	30509	27
343	पन्चकन्या गाउँपालिका	2	3	30510	27
344	शिवपुरी गाउँपालिका	2	3	30511	27
345	शंङ्खरापुर नगरपालिका	2	3	30601	28
346	कागेश्वरी मनहरा नगरपालिका	2	3	30602	28
347	गोकर्णेश्वर नगरपालिका	2	3	30603	28
348	बुढानिलकण्ठ नगरपालिका	2	3	30604	28
349	टोखा नगरपालिका	2	3	30605	28
350	तारकेश्वर नगरपालिका	2	3	30606	28
351	नागार्जुन नगरपालिका	2	3	30607	28
352	काठमाडौँ महानगरपालिका	2	3	30608	28
353	कीर्तिपुर नगरपालिका	2	3	30609	28
354	चन्द्रागिरी नगरपालिका	2	3	30610	28
355	दक्षिणकाली नगरपालिका	2	3	30611	28
356	चाँगुनारायण नगरपालिका	2	3	30701	29
357	भक्तपुर नगरपालिका	2	3	30702	29
358	मध्यपुर थिमी नगरपालिका	2	3	30703	29
359	सूर्यविनायक नगरपालिका	2	3	30704	29
360	महालक्ष्मी नगरपालिका	2	3	30801	30
361	ललितपुर महानगरपालिका	2	3	30802	30
362	गोदावरी नगरपालिका	2	3	30803	30
363	कोन्ज्योसोम गाउँपालिका	2	3	30804	30
364	महाङ्काल गाउँपालिका	2	3	30805	30
365	बाग्मती गाउँपालिका	2	3	30806	30
366	चौरीदेउराली गाउँपालिका	2	3	30901	31
367	भुम्लु गाउँपालिका	2	3	30902	31
368	मण्डन देउपुर नगरपालिका	2	3	30903	31
369	बनेपा नगरपालिका	2	3	30904	31
370	धुलिखेल नगरपालिका	2	3	30905	31
371	पाँचखाल नगरपालिका	2	3	30906	31
372	तेमाल गाउँपालिका	2	3	30907	31
373	नमोबुद्ध नगरपालिका	2	3	30908	31
374	पनौती नगरपालिका	2	3	30909	31
375	बेथानचोक गाउँपालिका	2	3	30910	31
376	रोशी गाउँपालिका	2	3	30911	31
377	महाभारत गाउँपालिका	2	3	30912	31
378	खानीखोला गाउँपालिका	2	3	30913	31
379	उमाकुण्ड गाउँपालिका	2	3	31001	32
380	गोकुलगङ्गा गाउँपालिका	2	3	31002	32
381	लिखु तामाकोसी गाउँपालिका	2	3	31003	32
382	रामेछाप नगरपालिका	2	3	31004	32
383	मन्थली नगरपालिका	2	3	31005	32
384	खाँडादेवी गाउँपालिका	2	3	31006	32
385	दोरम्बा गाउँपालिका	2	3	31007	32
386	सुनापती गाउँपालिका	2	3	31008	32
387	दुधौली नगरपालिका	2	3	31101	33
388	फिक्कल गाउँपालिका	2	3	31102	33
389	तीनपाटन गाउँपालिका	2	3	31103	33
390	गोलन्जोर गाउँपालिका	2	3	31104	33
391	कमलामाई नगरपालिका	2	3	31105	33
392	सुनकोशी गाउँपालिका	2	3	31106	33
393	ध्याङलेख गाउँपालिका	2	3	31107	33
394	मरिण गाउँपालिका	2	3	31108	33
395	हरिहरपुरगढी गाउँपालिका	2	3	31109	33
396	इन्द्रसरोवर गाउँपालिका	2	3	31201	34
397	थाहा नगरपालिका	2	3	31202	34
398	कैलाश गाउँपालिका	2	3	31203	34
399	राक्सिराङ्ग गाउँपालिका	2	3	31204	34
400	मनहरी गाउँपालिका	2	3	31205	34
401	हेटौडा उपमहानगरपालिका	2	3	31206	34
402	भिमफेदी गाउँपालिका	2	3	31207	34
403	मकवानपुरगढी गाउँपालिका	2	3	31208	34
404	बकैया गाउँपालिका	2	3	31209	34
405	बाग्मती गाउँपालिका	2	3	31210	34
406	कालिका नगरपालिका	2	3	31302	35
407	इच्छाकामना गाउँपालिका	2	3	31303	35
408	भरतपुर महानगरपालिका	2	3	31304	35
409	रत्ननगर नगरपालिका	2	3	31305	35
410	खैरहनी नगरपालिका	2	3	31306	35
411	माडी नगरपालिका	2	3	31307	35
412	चुमनुब्री गाउँपालिका	2	4	40101	36
413	अजिरकोट गाउँपालिका	2	4	40102	36
414	बारपाक सुलिकोट गाउँपालिका	2	4	40103	36
415	धार्चे गाउँपालिका	2	4	40104	36
416	भिमसेनथापा गाउँपालिका	2	4	40106	36
417	सिरानचोक गाउँपालिका	2	4	40107	36
418	पालुङ्गटार नगरपालिका	2	4	40108	36
419	गोरखा नगरपालिका	2	4	40109	36
420	शहीद लखन गाउँपालिका	2	4	40110	36
421	गण्डकी गाउँपालिका	2	4	40111	36
422	नार्पा भूमि गाउँपालिका	2	4	40201	37
423	मनाङ ङिस्याङ गाउँपालिका	2	4	40202	37
424	चामे गाउँपालिका	2	4	40203	37
425	नासों गाउँपालिका	2	4	40204	37
426	लो घेकर दामोदरकुण्ड गाउँपालिका	2	4	40301	38
427	घरपझोङ गाउँपालिका	2	4	40302	38
428	वारागुङ मुक्तिक्षेत्र गाउँपालिका	2	4	40303	38
429	लोमन्थाङ गाउँपालिका	2	4	40304	38
430	थासाङ गाउँपालिका	2	4	40305	38
431	अन्नपूर्ण गाउँपालिका	2	4	40401	39
432	रघुगंगा गाउँपालिका	2	4	40402	39
433	धवलागिरी गाउँपालिका	2	4	40403	39
434	मालिका गाउँपालिका	2	4	40404	39
435	मंगला गाउँपालिका	2	4	40405	39
436	बेनी नगरपालिका	2	4	40406	39
437	मादी गाउँपालिका	2	4	40501	40
438	माछापुच्छ्रे गाउँपालिका	2	4	40502	40
439	अन्नपूर्ण गाउँपालिका	2	4	40503	40
440	पोखरा महानगरपालिका	2	4	40504	40
441	रूपा गाउँपालिका	2	4	40505	40
442	दोर्दी गाउँपालिका	2	4	40601	41
443	मस्र्याङ्गदी गाउँपालिका	2	4	40602	41
444	क्ब्होलासोथार गाउँपालिका	2	4	40603	41
445	मध्यनेपाल नगरपालिका	2	4	40604	41
446	बेंसीशहर नगरापालिका	2	4	40605	41
447	सुन्दरबजार नगरपालिका	2	4	40606	41
448	राइनास नगरपालिका	2	4	40607	41
449	दूधपोखरी गाउँपालिका	2	4	40608	41
450	भानु नगरपालिका	2	4	40701	42
451	ब्यास नगरपालिका	2	4	40702	42
452	म्याग्दे गाउँपालिका	2	4	40703	42
453	शुक्लागण्डकी नगरपालिका	2	4	40704	42
454	भिमाद नगरपालिका	2	4	40705	42
455	घिरिङ्ग गाउँपालिका	2	4	40706	42
456	ऋषिङ्ग गाउँपालिका	2	4	40707	42
457	देवघाट गाउँपालिका	2	4	40708	42
458	बन्दिपुर गाउँपालिका	2	4	40709	42
459	आँबुखैरेनी गाउँपालिका	2	4	40710	42
460	बुलिङ्गटार गाउँपालिका	2	4	40802	43
461	बौदीकाली गाउँपालिका	2	4	40803	43
462	हुप्सेकोट गाउँपालिका	2	4	40804	43
463	देवचुली नगरपालिका	2	4	40805	43
464	कावासोती नगरपालिका	2	4	40806	43
465	मध्यबिन्दु नगरपालिका	2	4	40807	43
466	बिनयी त्रिवेणी गाउँपालिका	2	4	40808	43
467	पुतलीबजार नगरपालिका	2	4	40901	44
468	फेदीखोला गाउँपालिका	2	4	40902	44
469	आँधिखोला गाउँपालिका	2	4	40903	44
470	अर्जुनचौपारी गाउँपालिका	2	4	40904	44
471	भीरकोट नगरपालिका	2	4	40905	44
472	बिरुवा गाउँपालिका	2	4	40906	44
473	हरिनास गाउँपालिका	2	4	40907	44
474	चापाकोट नगरपालिका	2	4	40908	44
475	वालिङ्ग नगरपालिका	2	4	40909	44
476	गल्याङ नगरपालिका	2	4	40910	44
477	कालीगण्डकी गाउँपालिका	2	4	40911	44
478	मोदी गाउँपालिका	2	4	41001	45
479	जलजला गाउँपालिका	2	4	41002	45
480	कुश्मा नगरपालिका	2	4	41003	45
481	फलेबास नगरपालिका	2	4	41004	45
482	महाशिला गाउँपालिका	2	4	41005	45
483	बिहादी गाउँपालिका	2	4	41006	45
484	पैयुं गाउँपालिका	2	4	41007	45
485	बाग्लुङ्ग नगरपालिका	2	4	41101	46
486	काठेखोला गाउँपालिका	2	4	41102	46
487	ताराखोला गाउँपालिका	2	4	41103	46
488	तमानखोला गाउँपालिका	2	4	41104	46
489	ढोरपाटन नगरपालिका	2	4	41105	46
490	निसीखोला गाउँपालिका	2	4	41106	46
491	बडिगाड गाउँपालिका	2	4	41107	46
492	गल्कोट नगरपालिका	2	4	41108	46
493	बरेङ गाउँपालिका	2	4	41109	46
494	जैमिनी नगरपालिका	2	4	41110	46
495	पुथा उत्तरगंगा गाउँपालिका	2	5	50101	47
496	भूमे गाउँपालिका	2	5	50103	47
497	सुनछहरी गाउँपालिका	2	5	50201	48
498	थबाङ्ग गाउँपालिका	2	5	50202	48
499	परिवर्तन गाउँपालिका	2	5	50203	48
500	ग‌गादेव गाउँपालिका	2	5	50204	48
501	माडी गाउँपालिका	2	5	50205	48
502	त्रिवेणी गाउँपालिका	2	5	50206	48
503	रोल्पा नगरपालिका	2	5	50207	48
504	रुन्टीगढी गाउँपालिका	2	5	50208	48
505	सुनिल स्मृति गाउँपालिका	2	5	50209	48
506	लुङ्ग्री गाउँपालिका	2	5	50210	48
507	गौमुखी गाउँपालिका	2	5	50301	49
508	नौबहिनी गाउँपालिका	2	5	50302	49
509	झिमरुक गाउँपालिका	2	5	50303	49
510	प्यूठान नगरपालिका	2	5	50304	49
511	स्वर्गद्धारी नगरपालिका	2	5	50305	49
512	माण्डवी गाउँपालिका	2	5	50306	49
513	मल्लरानी गाउँपालिका	2	5	50307	49
514	ऐरावती गाउँपालिका	2	5	50308	49
515	सरुमारानी गाउँपालिका	2	5	50309	49
516	कालिगण्डकी गाउँपालिका	2	5	50401	50
517	सत्यवती गाउँपालिका	2	5	50402	50
518	चन्द्रकोट गाउँपालिका	2	5	50403	50
519	मुसिकोट नगरपालिका	2	5	50404	50
520	इस्मा गाउँपालिका	2	5	50405	50
521	मालिका गाउँपालिका	2	5	50406	50
522	मदाने गाउँपालिका	2	5	50407	50
523	धुर्कोट गाउँपालिका	2	5	50408	50
524	रेसुङ्गा नगरपालिका	2	5	50409	50
525	गुल्मी दरबार गाउँपालिका	2	5	50410	50
526	छत्रकोट गाउँपालिका	2	5	50411	50
527	रूरूक्षेत्र गाउँपालिका	2	5	50412	50
528	छत्रदेव गाउँपालिका	2	5	50501	51
529	मालारानी गाउँपालिका	2	5	50502	51
530	भूमिकास्थान नगरपालिका	2	5	50503	51
531	सन्धिखर्क नगरपालिका	2	5	50504	51
532	पाणिनी गाउँपालिका	2	5	50505	51
533	शितगंगा नगरपालिका	2	5	50506	51
534	रामपुर नगरपालिका	2	5	50601	52
535	पुर्वखोला गाउँपालिका	2	5	50602	52
536	रम्भा गाउँपालिका	2	5	50603	52
537	बगनासकाली गाउँपालिका	2	5	50604	52
538	तानसेन नगरपालिका	2	5	50605	52
539	रिब्दीकोट गाउँपालिका	2	5	50606	52
540	रैनादेवी छहरा गाउँपालिका	2	5	50607	52
541	तिनाउ गाउँपालिका	2	5	50608	52
542	माथागढी गाउँपालिका	2	5	50609	52
543	निस्दी गाउँपालिका	2	5	50610	52
544	बर्दघाट नगरपालिका	2	5	50701	53
545	सुनवल नगरपालिका	2	5	50702	53
546	रामग्राम नगरपालिका	2	5	50703	53
547	पाल्हीनन्दन गाउँपालिका	2	5	50704	53
548	सरावल गाउँपालिका	2	5	50705	53
549	प्रतापपुर गाउँपालिका	2	5	50706	53
550	सुस्ता गाउँपालिका	2	5	50707	53
551	देबदह नगरपालिका	2	5	50801	54
552	बुटवल उपमहानगरपालिका	2	5	50802	54
553	सैनामैना नगरपालिका	2	5	50803	54
554	कन्चन गाउँपालिका	2	5	50804	54
555	गैडहवा गाउँपालिका	2	5	50805	54
556	सुद्धोधन गाउँपालिका	2	5	50806	54
557	सियारी गाउँपालिका	2	5	50807	54
558	तिलोत्तमा नगरापालिका	2	5	50808	54
559	ओमसतिया गाउँपालिका	2	5	50809	54
560	रोहिणी गाउँपालिका	2	5	50810	54
561	सिद्धार्थनगर नगरपालिका	2	5	50811	54
562	मायादेवी गाउँपालिका	2	5	50812	54
563	लुम्बिनी सांस्कृतिक नगरपालिका	2	5	50813	54
564	कोटहीमाई गाउँपालिका	2	5	50814	54
565	सम्मरीमाई गाउँपालिका	2	5	50815	54
566	मर्चवारी गाउँपालिका	2	5	50816	54
567	बाणगंगा नगरपालिका	2	5	50901	55
568	बुद्धभूमि नगरपालिका	2	5	50902	55
569	शिवराज नगरपालिका	2	5	50903	55
570	बिजयनगर गाउँपालिका	2	5	50904	55
571	कृष्णनगर नगरपालिका	2	5	50905	55
572	महाराजगन्ज नगरपालिका	2	5	50906	55
573	कपिलबस्तु नगरपालिका	2	5	50907	55
574	यसोधरा गाउँपालिका	2	5	50908	55
575	मायादेवी गाउँपालिका	2	5	50909	55
576	शुद्धोधन गाउँपालिका	2	5	50910	55
577	बंगलाचुली गाउँपालिका	2	5	51001	56
578	घोराही उपमहानगरपालिका	2	5	51002	56
579	तुल्सीपुर उपमहानगरपालिका	2	5	51003	56
580	शान्तिनगर गाउँपालिका	2	5	51004	56
581	बबई गाउँपालिका	2	5	51005	56
582	दंगीशरण गाउँपालिका	2	5	51006	56
583	लमही नगरपालिका	2	5	51007	56
584	राप्ती गाउँपालिका	2	5	51008	56
585	गढवा गाउँपालिका	2	5	51009	56
586	राजपुर गाउँपालिका	2	5	51010	56
587	राप्ती सोनारी गाउँपालिका	2	5	51101	57
588	कोहलपुर नगरपालिका	2	5	51102	57
589	बैजनाथ गाउँपालिका	2	5	51103	57
590	खजुरा गाउँपालिका	2	5	51104	57
591	जानकी गाउँपालिका	2	5	51105	57
592	नेपालगञ्ज उपमहानगरपालिका	2	5	51106	57
593	डुडुवा गाउँपालिका	2	5	51107	57
594	नरैनापुर गाउँपालिका	2	5	51108	57
595	बाँसगढी नगरपालिका	2	5	51201	58
596	बारबर्दिया नगरपालिका	2	5	51202	58
597	ठाकुरबाबा नगरपालिका	2	5	51203	58
598	गेरुवा गाउँपालिका	2	5	51204	58
599	राजापुर नगरपालिका	2	5	51205	58
600	मधुवन नगरपालिका	2	5	51206	58
601	गुलरीया नगरपालिका	2	5	51207	58
602	बढैयाताल गाउँपालिका	2	5	51208	58
603	डोल्पो बुद्ध गाउँपालिका	2	6	60101	59
604	शे फोक्सुण्डो गाउँपालिका	2	6	60102	59
605	जगदुल्ला गाउँपालिका	2	6	60103	59
606	मुड्केचुला गाउँपालिका	2	6	60104	59
607	त्रिपूरासुन्दरी नगरपालिका	2	6	60105	59
608	ठूलीभेरी नगरपालिका	2	6	60106	59
609	छार्का ताङसोङ गाउँपालिका	2	6	60108	59
610	मुगुमकार्मारोग गाउँपालिका	2	6	60201	60
611	छायाँनाथ रारा नगरपालिका	2	6	60202	60
612	सोरु गाउँपालिका	2	6	60203	60
613	खत्याड गाउँपालिका	2	6	60204	60
614	चंखेली गाउँपालिका	2	6	60301	61
615	खार्पुनाथ गाउँपालिका	2	6	60302	61
616	सिमकोट गाउँपालिका	2	6	60303	61
617	नाम्खा गाउँपालिका	2	6	60304	61
618	सर्केगाड गाउँपालिका	2	6	60305	61
619	अदानचुली गाउँपालिका	2	6	60306	61
620	ताँजाकोट गाउँपालिका	2	6	60307	61
621	पातारासी गाउँपालिका	2	6	60401	62
622	कनका सुन्दरी गाउँपालिका	2	6	60402	62
623	सिंजा गाउँपालिका	2	6	60403	62
624	चन्दननाथ नगरपालिका	2	6	60404	62
625	गुठिचौर गाउँपालिका	2	6	60405	62
626	तातोपानी गाउँपालिका	2	6	60406	62
627	तिला गाउँपालिका	2	6	60407	62
628	हिमा गाउँपालिका	2	6	60408	62
629	पलाता गाउँपालिका	2	6	60501	63
630	पचाल झरना गाउँपालिका	2	6	60502	63
631	रास्कोट नगरपालिका	2	6	60503	63
632	सान्नी त्रिवेणी गाउँपालिका	2	6	60504	63
633	नरहरिनाथ गाउँपालिका	2	6	60505	63
634	खाँडाचक्र नगरपालिका	2	6	60506	63
635	तिलागुफा नगरपालिका	2	6	60507	63
636	महावै गाउँपालिका	2	6	60508	63
637	शुभ कालीका गाउँपालिका	2	6	60509	63
638	नौमुले गाउँपालिका	2	6	60601	64
639	महाबु गाउँपालिका	2	6	60602	64
640	भैरवी गाउँपालिका	2	6	60603	64
641	ठाँटीकाँध गाउँपालिका	2	6	60604	64
642	आठबीस नगरपालिका	2	6	60605	64
643	चामुण्डा बिन्द्रासैनी नगरपालिका	2	6	60606	64
644	दुल्लु नगरपालिका	2	6	60607	64
645	नारायण नगरपालिका	2	6	60608	64
646	भगवतीमाई गाउँपालिका	2	6	60609	64
647	डुङ्गेश्वर गाउँपालिका	2	6	60610	64
648	गुराँस गाउँपालिका	2	6	60611	64
649	बारेकोट गाउँपालिका	2	6	60701	65
650	कुसे गाउँपालिका	2	6	60702	65
651	जुनीचाँदे गाउँपालिका	2	6	60703	65
652	छेडागाड नगरपालिका	2	6	60704	65
653	शिवालय गाउँपालिका	2	6	60705	65
654	भेरीमालिका नगरपालिका	2	6	60706	65
655	नलगाड नगरपालिका	2	6	60707	65
656	आठबिसकोट नगरपालिका	2	6	60801	66
657	सानीभेरी गाउँपालिका	2	6	60802	66
658	बाँफीकोट गाउँपालिका	2	6	60803	66
659	मुसिकोट नगरपालिका	2	6	60804	66
660	त्रिवेणी गाउँपालिका	2	6	60805	66
661	चौरजहारी नगरपालिका	2	6	60806	66
662	दार्मा गाउँपालिका	2	6	60901	67
663	कुमाख गाउँपालिका	2	6	60902	67
664	बनगाड कुपिण्डे नगरपालिका	2	6	60903	67
665	सिद्धकुमाख गाउँपालिका	2	6	60904	67
666	बागचौर नगरपालिका	2	6	60905	67
667	छत्रेश्वरी गाउँपालिका	2	6	60906	67
668	शारदा नगरपालिका	2	6	60907	67
669	कालिमाटी गाउँपालिका	2	6	60908	67
670	त्रिवेणी गाउँपालिका	2	6	60909	67
671	कपुरकोट गाउँपालिका	2	6	60910	67
672	सिम्ता गाउँपालिका	2	6	61001	68
673	चिङ्गगाड गाउँपालिका	2	6	61002	68
674	लेकबेशी नगरपालिका	2	6	61003	68
675	गुर्भाकोट नगरपालिका	2	6	61004	68
676	भेरीगंगा नगरपालिका	2	6	61005	68
677	बराहताल गाउँपालिका	2	6	61007	68
678	पञ्चपुरी नगरपालिका	2	6	61008	68
679	चौकुने गाउँपालिका	2	6	61009	68
680	हिमाली गाउँपालिका	2	7	70101	69
681	गौमुल गाउँपालिका	2	7	70102	69
682	बुढीनन्दा नगरपालिका	2	7	70103	69
683	स्वामीकार्तिक खापर गाउँपालिका	2	7	70104	69
684	जगन्नाथ गाउँपालिका	2	7	70105	69
685	बडिमालिका नगरपालिका	2	7	70106	69
686	खप्तड छेडेदह गाउँपालिका	2	7	70107	69
687	बुढीगंगा नगरपालिका	2	7	70108	69
688	त्रिवेणी नगरपालिका	2	7	70109	69
689	साइपाल गाउँपालिका	2	7	70201	77
690	बुंगल नगरपालिका	2	7	70202	77
691	सूर्मा गाउँपालिका	2	7	70203	77
692	तालकोट गाउँपालिका	2	7	70204	77
693	मष्टा गाउँपालिका	2	7	70205	77
694	जयपृथ्वी नगरपालिका	2	7	70206	77
695	छबिस पाथिभरा गाउँपालिका	2	7	70207	77
696	दुर्गाथली गाउँपालिका	2	7	70208	77
697	केदारस्युँ गाउँपालिका	2	7	70209	77
698	बित्थडचिर गाउँपालिका	2	7	70210	77
699	थलारा गाउँपालिका	2	7	70211	77
700	खप्तडछान्ना गाउँपालिका	2	7	70212	77
701	ब्याँस गाउँपालिका	2	7	70301	70
702	दुहुँ गाउँपालिका	2	7	70302	70
703	महाकाली नगरपालिका	2	7	70303	70
704	नौगाड गाउँपालिका	2	7	70304	70
705	अपिहिमाल गाउँपालिका	2	7	70305	70
706	मार्मा गाउँपालिका	2	7	70306	70
707	शैल्यशिखर नगरपालिका	2	7	70307	70
708	मालिकार्जुन गाउँपालिका	2	7	70308	70
709	लेकम गाउँपालिका	2	7	70309	70
710	डीलासैनी गाउँपालिका	2	7	70401	71
711	दोगडाकेदार गाउँपालिका	2	7	70402	71
712	पुचौंडी नगरपालिका	2	7	70403	71
713	सुर्नया गाउँपालिका	2	7	70404	71
714	दशरथचन्द नगरपालिका	2	7	70405	71
715	पन्चेश्वर गाउँपालिका	2	7	70406	71
716	शिवनाथ गाउँपालिका	2	7	70407	71
717	मेलौली नगरपालिका	2	7	70408	71
718	सिगास गाउँपालिका	2	7	70410	71
719	नवदुर्गा गाउँपालिका	2	7	70501	72
720	अमरगढी नगरपालिका	2	7	70502	72
721	अजयमेरु गाउँपालिका	2	7	70503	72
722	भागेश्वर गाउँपालिका	2	7	70504	72
723	परशुराम नगरपालिका	2	7	70505	72
724	आलिताल गाउँपालिका	2	7	70506	72
725	गन्यापधुरा गाउँपालिका	2	7	70507	72
726	पूर्विचौकी गाउँपालिका	2	7	70601	73
727	सायल गाउँपालिका	2	7	70602	73
728	आदर्श गाउँपालिका	2	7	70603	73
729	शिखर नगरपालिका	2	7	70604	73
730	दिपायल सिलगढी नगरपालिका	2	7	70605	73
731	के.आई.सिं. गाउँपालिका	2	7	70606	73
732	बोगटान फुड्सिल गाउँपालिका	2	7	70607	73
733	बडीकेदार गाउँपालिका	2	7	70608	73
734	जोरायल गाउँपालिका	2	7	70609	73
735	पंचदेवल बिनायक नगरपालिका	2	7	70701	74
736	रामारोशन गाउँपालिका	2	7	70702	74
737	मेल्लेख गाउँपालिका	2	7	70703	74
738	साँफेबगर नगरपालिका	2	7	70704	74
739	चौरपाटी गाउँपालिका	2	7	70705	74
740	मंगलसेन नगरपालिका	2	7	70706	74
741	बान्नीगढी जयगढ गाउँपालिका	2	7	70707	74
742	कमलबजार नगरपालिका	2	7	70708	74
743	ढकारी गाउँपालिका	2	7	70709	74
744	तुर्माखाँद गाउँपालिका	2	7	70710	74
745	मोहन्याल गाउँपालिका	2	7	70801	75
746	चुरे गाउँपालिका	2	7	70802	75
747	गोदावरी नगरपालिका	2	7	70803	75
748	गौरीगंगा नगरपालिका	2	7	70804	75
749	घोडाघोडी नगरपालिका	2	7	70805	75
750	बर्दगोरिया गाउँपालिका	2	7	70806	75
751	लम्कि चुहा नगरपालिका	2	7	70807	75
752	जानकी गाउँपालिका	2	7	70808	75
753	जोशीपुर गाउँपालिका	2	7	70809	75
754	टिकापुर नगरपालिका	2	7	70810	75
755	भजनी नगरपालिका	2	7	70811	75
756	कैलारी गाउँपालिका	2	7	70812	75
757	धनगढी उपमहानगरपालिका	2	7	70813	75
758	कृष्णपुर नगरपालिका	2	7	70901	76
759	शुक्लाफाँटा नगरपालिका	2	7	70902	76
760	बेदकोट नगरपालिका	2	7	70903	76
761	भिमदत्त नगरपालिका	2	7	70904	76
762	माहाकाली नगरपालिका	2	7	70905	76
763	लालझाडी गाउँपालिका	2	7	70906	76
764	पुनर्वास नगरपालिका	2	7	70907	76
765	बेलौरी नगरपालिका	2	7	70908	76
766	बेलडाँडी गाउँपालिका	2	7	70909	76
8	Local Level 1	2	6	100	1
10	Local Level3	2	3	102	3
2	प्रदेश सरकार, Madesh प्रदेश	1	\N	\N	\N
\.


--
-- Data for Name: user_mgmt_leveltype; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_leveltype (id, type) FROM stdin;
1	P
2	L
\.


--
-- Data for Name: user_mgmt_menu; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_menu (id, created_at, updated_at, name, code, order_id, url, ic_class, parent_id) FROM stdin;
1	2021-11-15 10:13:30.191009+00	2021-11-15 10:13:30.191034+00	ड्यासबोर्ड	dashboard	1	dashboard:dashboard	\N	\N
2	2021-11-15 10:13:30.194864+00	2021-11-15 10:13:30.194881+00	कार्य सम्पादन सूचक	survey_setup	2	dashboard:home	\N	\N
3	2021-11-15 10:13:30.197345+00	2021-11-15 10:13:30.197362+00	विभाग/संस्था/मन्त्रालय सेटअप	departments	3	user_mgmt:depart_list	\N	\N
4	2021-11-15 10:13:30.199815+00	2021-11-15 10:13:30.19983+00	सुधार अनुमति सूचक	correction_req	4	dashboard:correction_req	\N	\N
5	2021-11-15 10:13:30.202225+00	2021-11-15 10:13:30.202241+00	प्रयोगकर्ता सेटअप	users	5	user_mgmt:user_list	\N	\N
6	2021-11-15 10:13:30.204584+00	2021-11-15 10:13:30.2046+00	भूमिका सेटअप	roles	6	user_mgmt:role_list	\N	\N
7	2021-11-15 10:13:30.206982+00	2021-11-15 10:13:30.206997+00	मास्टर कन्फिगरेसन	master	7	dashboard:master_configuration	\N	\N
8	2021-11-15 10:13:30.209355+00	2021-11-15 10:13:30.20937+00	गतिविधि लग	activity_log	8	dashboard:activity_log	\N	\N
9	2021-11-15 10:13:30.211725+00	2021-11-15 10:13:30.21174+00	गुनासोहरु	complaints	9	dashboard:list_complaints	\N	\N
10	2021-11-15 10:13:30.214102+00	2021-11-15 10:13:30.214118+00	भरिएको कार्य सम्पादनका सूचकहरु	survey_list	10	dashboard:survey_list	\N	\N
12	2021-11-16 04:06:06.31611+00	2021-11-17 04:58:56.98695+00	मूल्याङ्कन पुनरावलोकन सम्बन्धी गुनासो	appraisal_review_request	12	dashboard:appraisal_review_request	\N	\N
11	2021-11-15 10:13:30.216457+00	2021-11-17 04:59:30.583561+00	प्रतिवेदनहरु	reports	11	report:reports	\N	\N
\.


--
-- Data for Name: user_mgmt_menupermission; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_menupermission (id, can_add, can_change, can_view, can_delete, can_approve, menu_id, role_id) FROM stdin;
20	t	t	t	t	f	1	2
19	t	t	t	t	f	2	2
13	t	t	t	t	f	3	2
18	t	t	t	t	f	4	2
1	t	t	t	t	f	1	1
10	t	t	t	t	f	2	1
12	t	t	t	t	f	5	2
9	f	f	f	f	f	3	1
11	t	t	t	t	f	6	2
8	t	t	t	t	f	4	1
21	t	t	t	t	f	5	1
17	t	t	t	t	f	7	2
7	f	f	f	f	f	7	1
2	t	t	t	t	f	8	2
6	t	t	t	t	f	8	1
5	t	t	t	t	f	9	1
16	t	t	t	t	f	10	2
22	t	t	t	t	f	10	1
15	t	t	t	t	f	11	2
4	t	t	t	t	f	11	1
3	t	t	t	t	f	12	1
14	t	t	t	t	f	12	2
\.


--
-- Data for Name: user_mgmt_role; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_role (id, created_at, updated_at, name, "desc") FROM stdin;
2	2021-11-16 05:52:50.14483+00	2022-06-01 09:10:19.394978+00	Office Head	
1	2021-11-15 17:27:26.20119+00	2022-07-19 05:07:58.425554+00	Province Admin	
\.


--
-- Data for Name: user_mgmt_role_menus; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_role_menus (id, role_id, menu_id) FROM stdin;
1	1	1
2	2	8
3	1	2
4	1	3
5	1	4
6	1	7
7	1	8
8	1	9
9	1	11
10	1	12
11	2	1
12	2	2
13	2	3
14	2	4
15	2	5
16	2	6
17	2	7
18	2	10
19	2	11
20	2	12
21	1	5
22	1	10
\.


--
-- Data for Name: user_mgmt_user; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, is_first_login, department_id, address, mobile_num, full_name, designation, level_id, personal_email, post_id, is_office_head) FROM stdin;
8	pbkdf2_sha256$260000$YXQfknZ4h7tg9kIcWOvx1h$8Z3Xc/VwK3OYFkKB4IOaO0T6SylGLqUJy72MhEVVX7w=	2021-11-23 11:04:31.880137+00	f	sambhunath@yopmail.com			sambhunath@yopmail.com	f	t	2021-11-15 10:41:29.908102+00	f	1	\N	9854020150	नन्दलाल राय यादव	\N	2	nandlalrayyadav@yopmail.com	8	f
23	pbkdf2_sha256$260000$BEkYK76O5rNsPq4TKKF4Zu$F9wpZlzm+UfqFVAQrVewdk4R7J2KMeW5SdIBTBkV2Ko=	\N	f	apihimal_office@yopmail.com			apihimal_office@yopmail.com	f	t	2021-12-12 05:57:30.676016+00	t	\N	\N	9898767656	API Himal User	\N	705	apihimal_user@yopmail.com	\N	f
2	pbkdf2_sha256$260000$EZQrhecSLLq2SAcPdEoaxi$E8Ky3qDEwqBRNykOztdlQI4jB1DKa7MqFn5NChWe08Y=	2021-11-15 10:36:47.358377+00	f	sanjeevkrai_moitfe@yopmail.com			sanjeevkrai_moitfe@yopmail.com	f	t	2021-11-15 10:28:57.325292+00	f	3	\N	9852070224	सन्जीव कुमार राई	\N	1	sanjeevkrai4@yopmail.com	1	f
4	pbkdf2_sha256$260000$Cqte35Uk6au6SVVscCmwXN$JuRZ5I6DutVYzfi1oibZWvkbHMB+wo69HmyBph5PXd0=	2021-11-15 10:37:34.752315+00	f	yambhusal_ocmcm@yopmail.com			yambhusal_ocmcm@yopmail.com	f	t	2021-11-15 10:30:22.46727+00	f	1	\N	9851209355	यामप्रसाद भुसाल	\N	2	yam_bhusal@yopmail.com	1	f
13	pbkdf2_sha256$260000$VVEvt1iYzvj0HZDvDKnrOw$8FBfQeMYQz1oFm3q+K6yh6gxNK2Ropm8EOjDqot0nGQ=	2021-11-19 10:57:46.030433+00	f	mohanshrestha_galchhimun@yopmail.com			mohanshrestha_galchhimun@yopmail.com	f	t	2021-11-15 10:45:56.860847+00	f	\N	\N	9851343445	Mohan Shrestha	\N	13	mohanshrestha_galchhimun@yopmail.com	1	f
6	pbkdf2_sha256$260000$rapwEXtH3dLAtd2wQEP2EG$0ZRjfBH/n6K6BPHZUaZsvzb+TE3FLG1pLu8tDCTysTk=	2021-11-15 10:39:14.311526+00	f	gangakharel_sudurpashchim@yopmail.com			gangakharel_sudurpashchim@yopmail.com	f	t	2021-11-15 10:38:34.260947+00	f	1	\N	91523232	गंगा बहादुर खरेल	\N	7	gangabdrkharel@yopmail.com	1	f
1	pbkdf2_sha256$260000$wl5dQEBvBLfi5OQJIO6iuk$+VLvGxaGZRwFnoOsQpUp56PkqBR6n/M3EIYCO4pX2XE=	2023-03-16 05:11:01.706386+00	t	admin@mail.com			admin@mail.com	t	t	2021-11-15 10:12:45+00	f	\N	\N	\N	admin admin	\N	8	admin@yopmail.com	\N	t
7	pbkdf2_sha256$260000$6ej54DuUZzXfwfA5h3NE89$IbOILT+coa9YWVbzEFHd9PwpQKRyPUZRDjUwZ/pPVpc=	2021-11-16 10:00:52.281914+00	f	ganendra_gandaki@yopmail.com			ganendra_gandaki@yopmail.com	f	t	2021-11-15 10:40:21.234651+00	f	3	\N	9846467357	घनेन्द्र बहादुर खनाल	\N	4	ganendra_khanal@yopmail.com	3	f
12	pbkdf2_sha256$260000$v4IWDPCCEqkgnFwHDRjywb$/2tUJ6pXC2LPLE3I9sPR/HAkc7Yd0kO/SBlw+HIrw74=	2021-11-15 17:54:38.553885+00	f	kamalyadav_agnisairmun@yopmail.com			kamalyadav_agnisairmun@yopmail.com	f	t	2021-11-15 10:45:32.2728+00	f	\N	\N	9829788575	कमलदेव यादव	\N	14	nitesh280124@yopmail.com	3	f
11	pbkdf2_sha256$260000$f4rKUEkalorib91r2sJNTh$fHXe4Y+qFYTWuOvqhZrhlPGTrwxUvtxvbLBsm4ugwhM=	2021-11-25 04:11:21.867928+00	f	gita_panauti@yopmail.com			gita_panauti@yopmail.com	f	t	2021-11-15 10:45:06.066462+00	f	\N	\N	9837687244	Gita Tamang	\N	16	gita_tamang@yopmail.com	5	f
5	pbkdf2_sha256$260000$ODEUkAgqxdqvfWV71536WT$ZwjEf+wcjZDXmB2uvRbZlWyH2cCvJDSEG0vjjqAp2/c=	2022-04-13 04:13:04.790478+00	f	sharmabharatkumar11@yopmail.com			sharmabharatkumar11@yopmail.com	f	t	2021-11-15 10:31:14.978831+00	f	2	\N	9857821521	Bharat Kumar Sharma	\N	6	sharma_kumar11@yopmail.com	1	f
3	pbkdf2_sha256$260000$JkV5quvXDx8ONclwNGxFrB$pyRyndcAW6nByHKkw9QDRhEWuIZ3MH9hHOE3VzUMlk8=	2021-11-17 03:43:08.31553+00	f	moeap.gandaki@yopmail.com			moeap.gandaki@yopmail.com	f	t	2021-11-15 10:29:43.549376+00	f	2	\N	9856053882	Ramesh Sharma	\N	4	ramesh_sharma1985@yopmail.com	2	f
9	pbkdf2_sha256$260000$qlk4qlZXp2H3wffgP3hDra$DZdZq9TsBW+7gTRi+ziN1M70nCuLjNs5YxkaJqggMrM=	2021-11-15 10:46:43.01784+00	f	ito.kakanimun@yopmail.com			ito.kakanimun@yopmail.com	f	t	2021-11-15 10:43:30.852425+00	f	\N	\N	9851241660	महेन्द्र बहादुर नेपाल	\N	13	mahendranepal1983@yopmail.com	7	f
15	pbkdf2_sha256$260000$SZOpuP1B0TiYEvvZ7bDwAD$d6oeuKEI7pOIpBi0RHSbYI5uzjr0DAblmP7AeIQ9oYY=	2022-07-25 05:04:45.768753+00	f	lumbini_arthik@yopmail.com			lumbini_arthik@yopmail.com	f	t	2021-11-15 18:13:16.020708+00	f	2	\N	998837495	Narendra Paudel	\N	5	narendra_paudel@yopmail.com	1	f
18	pbkdf2_sha256$260000$ysKamjuVWBfqOmzdGaaEfX$kK3cQsTzwVQ6xBozC8hPzenkQcfiVybb8t4Q8X7tnk0=	2021-11-24 09:28:42.099426+00	f	sudarpaschim_arthik@yopmail.com			sudarpaschim_arthik@yopmail.com	f	t	2021-11-16 05:48:09.319795+00	f	2	\N	9841627584	Shyam Chand	\N	7	shyam_chand@yopmail.com	5	f
25	pbkdf2_sha256$260000$4cUKt3AwSpR3MrrkMoP3t6$k7S5kwJ0FCfOPmEf/+2sVRj/Mxc4PFjUtiQRH8xE6Es=	\N	f	new_test99@yopmail.com			new_test99@yopmail.com	f	t	2021-12-15 08:32:10.252858+00	t	2	\N	87	new_test99@yopmail.com	\N	1	new_test99@yopmail.com	\N	f
10	pbkdf2_sha256$260000$tp6gIzxtPnaNUtZCs9CpnJ$/gIAFtedaQ9njDOoj1MRK20eGNyef63IWyn5viyJjok=	2021-11-22 06:57:38.048466+00	f	haribahadur_rapti@yopmail.com			haribahadur_rapti@yopmail.com	f	t	2021-11-15 10:44:25.773123+00	f	\N	\N	9885463513	Hari Bahadur	\N	17	hari_bahadur@yopmail.com	6	f
17	pbkdf2_sha256$260000$MvnEHyakzM75pJDHPiecix$1OfT/wT1hGVTAqNk3V3Rs4gPr4fuhbOhv8d6XIeD7lU=	2022-06-01 15:59:42.852393+00	f	province2_arthik@yopmail.com			province2_arthik@yopmail.com	t	t	2021-11-15 18:20:36.899039+00	f	2	\N	9811636363	Arjun Shah	\N	2	arjun_shah@yopmail.com	2	f
22	pbkdf2_sha256$260000$HeMjqmKZrCf2kqDPQy0Oe4$EzUXeE5Ml+Y9YpqPnZuDy85XmgbkKpDWuDD4BEqvoX8=	2021-12-03 06:27:18.377748+00	f	koiralakhomraj_lumbini@yopmail.com			koiralakhomraj_lumbini@yopmail.com	f	t	2021-12-03 06:26:23.350996+00	f	2	\N	9857072015	खोमराज कोइराला	\N	5	koiralakhomraj@yopmail.com	1	f
16	pbkdf2_sha256$260000$w7WTKhJNSg947THEyRmmtI$RH/RjbeXztF1S/6HDWfKMA/W0pSwxk1Eqps5sR818jI=	2021-12-06 06:10:13.801556+00	f	province1_arthik@yopmail.com			province1_arthik@yopmail.com	f	t	2021-11-15 18:16:35.01572+00	f	2	\N	9948593211	Bishal Rai	\N	1	bishal_rai@yopmail.com	\N	f
24	pbkdf2_sha256$260000$CCdj7KlZjErCgdIvhpD9fv$fAf99fuKLkC8lLupFtYh3AAuH+7h56uFUUGuXkrlKcw=	2021-12-12 06:58:18.059048+00	f	new_arthik_pradesh3@yopmail.com			new_arthik_pradesh3@yopmail.com	f	t	2021-12-12 06:49:51.679234+00	f	2	\N	9875837463	Ramesh Baral	\N	3	ramesh_baral@yopmail.com	5	f
26	pbkdf2_sha256$260000$jEtTJYj1RlUi59l1YAyrbr$GZ6cN7qOI8QF50rONvAeWEnlMCjM1kuD5Qh7i6QwROM=	\N	f	new_test98@yopmail.com			new_test98@yopmail.com	f	t	2021-12-15 09:12:09.189634+00	t	3	\N	9898989898	new_test98@yopmail.com	\N	2	new_test98@yopmail.com	\N	f
19	pbkdf2_sha256$260000$CBMdg2UX0QbM18uLpxNzMq$q5eZ/fpC49d9btG4uLzD89vEMjEIUlprTz7MeJFdMvU=	2022-06-03 10:25:02.661046+00	f	bitta_ayog_pradesh2@yopmail.com			bitta_ayog_pradesh2@yopmail.com	f	t	2021-11-24 06:31:46.841716+00	f	2	\N	9875637658	Ayush Shakya	\N	2	ayush_shakya@yopmail.com	6	f
14	pbkdf2_sha256$260000$WDJIlhyuEmRnsuhiYKFyEq$FKTojUlXbSs3qbhAbqAnrOLGUvqJa4Rf2UXHP11j7Gk=	2022-07-06 11:54:41.497203+00	f	bagmati_arthik@yopmail.com			bagmati_arthik@yopmail.com	f	t	2021-11-15 18:10:54.085154+00	f	2	\N	987748378	Ashesh Bhattarai	\N	3	ashesh_bhattarai@yopmail.com	5	f
40	pbkdf2_sha256$260000$Jd3rNyb39vsU0s6OqGwfxg$GdfqelqEGl7L2v7+okCo5aoIa1S+2YTwUg/GVcWlYsE=	\N	f	province2_arthik2@yopmail.com			province2_arthik2@yopmail.com	f	t	2022-06-01 09:18:14.146932+00	t	2	\N	9811636366	shyam buda	\N	4	province2_arthik2@yopmail.com	1	f
27	pbkdf2_sha256$260000$mf7ldmL0X9UJV9QZIROG85$CraoCnFxkRJ8UMzDkhHIG1ufNPbvwvtBQdKdaDNc05g=	2022-04-07 04:56:27.845571+00	f	tourism_bagmati@yopmail.com			tourism_bagmati@yopmail.com	f	t	2022-04-07 04:54:37.93558+00	f	3	\N	9898989898	Ram Silwal	\N	3	ram_silwal@yopmail.com	5	f
31	pbkdf2_sha256$260000$PvGXXaCZ1oVKFipZBYfWDW$YCxLN4X+CjoW8Lc5H1OktiEPSswXHFWUih7lKVssgJ4=	2022-07-19 10:09:24.691932+00	f	admin_madesh@yopmail.com			admin_madesh@yopmail.com	t	t	2022-04-12 03:46:45.656712+00	f	2	\N	9999999999	Madesh Admin	\N	2	admin_madesh@yopmail.com	2	f
28	pbkdf2_sha256$260000$bGdZsHhybxzp4rgTZBMR09$hvVrNDsKVoZ4EWH7qE0a5h13caZr3i/sckKE072MlmU=	2022-04-07 09:50:30.798659+00	f	aanapurna55@yopmail.com			aanapurna55@yopmail.com	f	t	2022-04-07 09:49:48.302336+00	f	\N	\N	9999999999	Purna Thapa	\N	431	purna_thapa@yopmail.com	1	f
29	pbkdf2_sha256$260000$P0GNh46U7V8c78ootGueA8$WkJaozC5vr6XfUQeuAD+zL5Deh2pDV7wJ+p5UcVv6BQ=	\N	f	paryatan_prov1@yopmail.com			paryatan_prov1@yopmail.com	f	t	2022-04-08 04:00:03.945423+00	t	3	\N	9999999999	Paryatan Prov	\N	1	paryatan_prov1@yopmail.com	4	f
42	pbkdf2_sha256$260000$CVa9iJNdS4RQmtQNDpYkUY$e6hb+TfsxBx3bSyNFJH+Ne87IFwWWgaEH8D2uxG1t68=	\N	f	office_madesh_arthik@yopmail.com			office_madesh_arthik@yopmail.com	f	t	2022-10-20 09:50:20.570928+00	t	2	\N	9898989898	Madesh Admin	\N	2	personal_madesh_arthik@yopmail.com	3	f
41	pbkdf2_sha256$260000$NMUTgeb9Wd8zEjmPnEwPj8$ElV79iOw1/7v649swncjc/xbDJ83AOx+zMDtjxMRnsI=	\N	f	doit.karmali@yopmail.com			doit.karmali@yopmail.com	f	t	2022-06-13 04:42:37.898481+00	t	5	\N	9999999999	DOIT Karnali	\N	6	doit.karmali@yopmail.com	1	f
30	pbkdf2_sha256$260000$ejx5tlhAaaIApgqMitFpCG$qdz6Z4MFX8MfwQht/v5kZNpWzR5txJvtamp8QVYkNAE=	2022-04-08 06:03:51.853094+00	f	bagmati_arthik9@yopmail.com			bagmati_arthik9@yopmail.com	f	t	2022-04-08 05:55:32.613233+00	f	2	\N	9887655432	Dil Kumar	\N	3	dil_kumar@yopmail.com	5	f
32	pbkdf2_sha256$260000$BA76vwwopXBec3251Kp0mH$U65HSzjUgdAox5bm1PqWBESL+VabQQJ/zP5p53DMDvs=	\N	f	gouhacriqueuhau-5587@yopmail.com			gouhacriqueuhau-5587@yopmail.com	f	t	2022-05-29 16:30:05.218127+00	t	4	\N	9811636361	ram thapa	\N	7	wousepacecra-6893@yopmail.com	6	f
33	pbkdf2_sha256$260000$B44zx5tfZqcYJuEVhAs5ck$YOBWivriRIiU52rvhbUanbwacv6ROH65nd5/VJ/tcSk=	\N	f	wousepacecra-6893@yopmail.com			wousepacecra-6893@yopmail.com	f	t	2022-05-30 06:51:49.18144+00	t	2	\N	9811636361	ram thapa	\N	2	ram@gmail.com	5	f
34	pbkdf2_sha256$260000$0ayFqiNvM1JyPmgDHcmelD$+bLKi27+DXBQ8LXuc+d1z1+TeXZY3o05/7qwZBwkGk4=	\N	f	hizouddedeiffi-9094@yopmail.com			hizouddedeiffi-9094@yopmail.com	f	t	2022-05-30 06:57:46.36059+00	t	3	\N	9811636361	ram thapa	\N	6	narenpyakurel@gmail.com	\N	f
35	pbkdf2_sha256$260000$CE9fdrX8saRD3b9BJaW3yK$wEQo7RehL2Py/Pvm/qJ5bf3Qh4Z41i11uhAjIv+Z9Ag=	\N	f	frougroijawallau-5260@yopmail.com			frougroijawallau-5260@yopmail.com	f	t	2022-05-30 07:03:15.793748+00	t	3	\N	9811636361	ram thapa	\N	6	narenpyakurel@gmail.com	3	f
36	pbkdf2_sha256$260000$o2MmbaVw1fMaSjz3BLLmNo$G2Vyusf9x3JGDdcCt9nTP/WRMV4bwtL81YFnMfQ4IzU=	\N	f	vedeugradiveu-3089@yopmail.com			vedeugradiveu-3089@yopmail.com	f	t	2022-05-30 07:05:27.270432+00	t	2	\N	9811636361	ram thapa	\N	7	narenpyakurel@gmail.com	2	f
39	pbkdf2_sha256$260000$JKsRyJoOhgEcZL3ugXyaGC$qJS7PLpZQspmoQtFI1opiF7nBqb/s1f8DP1kBybhVos=	2022-07-06 12:02:04.365429+00	f	province2_arthik1@yopmail.com			province2_arthik1@yopmail.com	f	t	2022-06-01 09:15:43.072439+00	f	2	\N	9811636366	rada buda	\N	2	province2_arthik1@yopmail.com	1	f
43	pbkdf2_sha256$260000$mKMKvZFkXx0RqF7p0K3fM0$lJSJxXJB997fl9E3J77xHyROUoHLEXCsHDClKvkrBEQ=	2022-10-20 10:01:52.752738+00	f	anu@yopmail.com			anu@yopmail.com	f	t	2022-10-20 09:57:52+00	f	2	\N	9898989898	Anu Khadka	\N	4	anu123@yopmail.com	2	f
37	pbkdf2_sha256$260000$FBcUUEkleyoo4FLjemug80$ZsqR2fkD1tfR+z2U6utSBOu7qMHdBi1YlcRSCnfyyHo=	\N	f	karnalipardesh@yopmai.com			karnalipardesh@yopmai.com	f	t	2022-06-01 09:05:35.325285+00	t	4	\N	9811636364	gopal	\N	6	gopal@yopmail.com	1	f
38	pbkdf2_sha256$260000$OWyVSHeKktLS3AQyHPq25D$fpPucbp1Txa7Q9Ji64bilnQf5s2/9/QtODG0dA9dA1Q=	\N	f	province21_arthik@yopmail.com			province21_arthik@yopmail.com	f	t	2022-06-01 09:08:01.998128+00	t	2	\N	9811636363	rada thapa	\N	6	province21_arthik@yopmail.com	1	f
44	pbkdf2_sha256$260000$IsatdaX9cO8XR9DX5spmDm$UZA67VLHID7gRsaRxpUholXZlOBlIqbo+/HRzhroSRg=	\N	f	nishma@yopmail.com			nishma@yopmail.com	f	t	2023-03-09 05:05:34.587301+00	t	4	\N	9898892832	Nishma Kafle	\N	1	nishma@yopmail.com	1	f
45	pbkdf2_sha256$260000$W4N7Hi0S42QvWgxsHeqpcR$dT3AFqtPWRW0AR6w2ta+wVTXAnN189pNCQ/uwzRt1IM=	2023-06-28 09:01:01.730855+00	t	admin@admin.com			admin@admin.com	t	t	2023-06-19 10:23:39.223247+00	f	\N	\N	\N	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: user_mgmt_user_groups; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: user_mgmt_user_roles; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_user_roles (id, user_id, role_id) FROM stdin;
5	31	1
6	32	1
7	17	2
8	44	2
\.


--
-- Data for Name: user_mgmt_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: user_mgmt_userpost; Type: TABLE DATA; Schema: public; Owner: nnrfc
--

COPY public.user_mgmt_userpost (id, created_at, updated_at, name) FROM stdin;
1	2021-11-15 10:51:42.205718+00	2021-11-15 10:51:42.207049+00	सचिव
2	2021-11-15 10:51:53.865615+00	2021-11-15 10:51:53.866756+00	सह-सचिव
3	2021-11-15 10:52:00.802767+00	2021-11-15 10:52:00.804237+00	उप-सचिव
4	2021-11-15 10:52:48.024082+00	2021-11-15 10:52:48.025009+00	\tसिनियर डिभिजनल इन्जिनियर
5	2021-11-15 10:53:03.705651+00	2021-11-15 10:55:59.629939+00	लेखा अधिकृत
6	2021-11-15 11:05:16.496688+00	2021-11-15 11:05:16.497687+00	इन्जिनियर
7	2021-11-15 17:02:49.626199+00	2021-11-15 17:02:49.627201+00	प्रमुख प्रशासकीय अधिकृत
8	2021-11-15 17:31:30.575453+00	2021-11-15 17:31:30.576636+00	वन संरक्षण/व्यवस्थापन अधिकृत
9	2023-03-08 08:11:17.609623+00	2023-03-08 08:11:17.611445+00	
10	2023-03-08 08:11:19.455407+00	2023-03-08 08:11:19.456719+00	
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 128, true);


--
-- Name: axes_accessattempt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.axes_accessattempt_id_seq', 35, true);


--
-- Name: axes_accesslog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.axes_accesslog_id_seq', 120, true);


--
-- Name: core_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_answer_id_seq', 545, true);


--
-- Name: core_answerdocument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_answerdocument_id_seq', 121, true);


--
-- Name: core_appraisalreviewrequest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_appraisalreviewrequest_id_seq', 12, true);


--
-- Name: core_centralbody_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_centralbody_id_seq', 1, false);


--
-- Name: core_complaint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_complaint_id_seq', 6, true);


--
-- Name: core_correctionactivitylog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_correctionactivitylog_id_seq', 16, true);


--
-- Name: core_fillsurvey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_fillsurvey_id_seq', 16, true);


--
-- Name: core_fiscalyear_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_fiscalyear_id_seq', 3, true);


--
-- Name: core_localbody_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_localbody_id_seq', 1, false);


--
-- Name: core_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_notification_id_seq', 115, true);


--
-- Name: core_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_option_id_seq', 167, true);


--
-- Name: core_provincebody_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_provincebody_id_seq', 1, false);


--
-- Name: core_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_question_id_seq', 56, true);


--
-- Name: core_survey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_survey_id_seq', 2, true);


--
-- Name: core_surveycorrection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.core_surveycorrection_id_seq', 15, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 813, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 32, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 106, true);


--
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- Name: user_mgmt_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_department_id_seq', 5, true);


--
-- Name: user_mgmt_district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_district_id_seq', 77, true);


--
-- Name: user_mgmt_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_level_id_seq', 768, true);


--
-- Name: user_mgmt_leveltype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_leveltype_id_seq', 1, false);


--
-- Name: user_mgmt_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_menu_id_seq', 12, true);


--
-- Name: user_mgmt_menupermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_menupermission_id_seq', 22, true);


--
-- Name: user_mgmt_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_role_id_seq', 2, true);


--
-- Name: user_mgmt_role_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_role_menus_id_seq', 22, true);


--
-- Name: user_mgmt_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_user_groups_id_seq', 1, false);


--
-- Name: user_mgmt_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_user_id_seq', 45, true);


--
-- Name: user_mgmt_user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_user_roles_id_seq', 8, true);


--
-- Name: user_mgmt_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_user_user_permissions_id_seq', 1, false);


--
-- Name: user_mgmt_userpost_id_seq; Type: SEQUENCE SET; Schema: public; Owner: nnrfc
--

SELECT pg_catalog.setval('public.user_mgmt_userpost_id_seq', 10, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: axes_accessattempt axes_accessattempt_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.axes_accessattempt
    ADD CONSTRAINT axes_accessattempt_pkey PRIMARY KEY (id);


--
-- Name: axes_accessattempt axes_accessattempt_username_ip_address_user_agent_8ea22282_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.axes_accessattempt
    ADD CONSTRAINT axes_accessattempt_username_ip_address_user_agent_8ea22282_uniq UNIQUE (username, ip_address, user_agent);


--
-- Name: axes_accesslog axes_accesslog_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.axes_accesslog
    ADD CONSTRAINT axes_accesslog_pkey PRIMARY KEY (id);


--
-- Name: core_answer core_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer
    ADD CONSTRAINT core_answer_pkey PRIMARY KEY (id);


--
-- Name: core_answerdocument core_answerdocument_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answerdocument
    ADD CONSTRAINT core_answerdocument_pkey PRIMARY KEY (id);


--
-- Name: core_appraisalreviewrequest core_appraisalreviewrequest_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_appraisalreviewrequest
    ADD CONSTRAINT core_appraisalreviewrequest_pkey PRIMARY KEY (id);


--
-- Name: core_centralbody core_centralbody_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_centralbody
    ADD CONSTRAINT core_centralbody_name_key UNIQUE (name);


--
-- Name: core_centralbody core_centralbody_name_np_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_centralbody
    ADD CONSTRAINT core_centralbody_name_np_key UNIQUE (name_np);


--
-- Name: core_centralbody core_centralbody_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_centralbody
    ADD CONSTRAINT core_centralbody_pkey PRIMARY KEY (id);


--
-- Name: core_complaint core_complaint_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_complaint
    ADD CONSTRAINT core_complaint_pkey PRIMARY KEY (id);


--
-- Name: core_correctionactivitylog core_correctionactivitylog_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_correctionactivitylog
    ADD CONSTRAINT core_correctionactivitylog_pkey PRIMARY KEY (id);


--
-- Name: core_fillsurvey core_fillsurvey_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fillsurvey
    ADD CONSTRAINT core_fillsurvey_pkey PRIMARY KEY (id);


--
-- Name: core_fiscalyear core_fiscalyear_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fiscalyear
    ADD CONSTRAINT core_fiscalyear_name_key UNIQUE (name);


--
-- Name: core_fiscalyear core_fiscalyear_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fiscalyear
    ADD CONSTRAINT core_fiscalyear_pkey PRIMARY KEY (id);


--
-- Name: core_localbody core_localbody_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_localbody
    ADD CONSTRAINT core_localbody_name_key UNIQUE (name);


--
-- Name: core_localbody core_localbody_name_np_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_localbody
    ADD CONSTRAINT core_localbody_name_np_key UNIQUE (name_np);


--
-- Name: core_localbody core_localbody_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_localbody
    ADD CONSTRAINT core_localbody_pkey PRIMARY KEY (id);


--
-- Name: core_notification core_notification_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_notification
    ADD CONSTRAINT core_notification_pkey PRIMARY KEY (id);


--
-- Name: core_option core_option_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_option
    ADD CONSTRAINT core_option_pkey PRIMARY KEY (id);


--
-- Name: core_provincebody core_provincebody_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_provincebody
    ADD CONSTRAINT core_provincebody_name_key UNIQUE (name);


--
-- Name: core_provincebody core_provincebody_name_np_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_provincebody
    ADD CONSTRAINT core_provincebody_name_np_key UNIQUE (name_np);


--
-- Name: core_provincebody core_provincebody_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_provincebody
    ADD CONSTRAINT core_provincebody_pkey PRIMARY KEY (id);


--
-- Name: core_question core_question_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_question
    ADD CONSTRAINT core_question_pkey PRIMARY KEY (id);


--
-- Name: core_survey core_survey_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_survey
    ADD CONSTRAINT core_survey_name_key UNIQUE (name);


--
-- Name: core_survey core_survey_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_survey
    ADD CONSTRAINT core_survey_pkey PRIMARY KEY (id);


--
-- Name: core_surveycorrection core_surveycorrection_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_surveycorrection
    ADD CONSTRAINT core_surveycorrection_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_department user_mgmt_department_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_department
    ADD CONSTRAINT user_mgmt_department_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_district user_mgmt_district_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_district
    ADD CONSTRAINT user_mgmt_district_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_level user_mgmt_level_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_level
    ADD CONSTRAINT user_mgmt_level_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_leveltype user_mgmt_leveltype_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_leveltype
    ADD CONSTRAINT user_mgmt_leveltype_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_menu user_mgmt_menu_code_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menu
    ADD CONSTRAINT user_mgmt_menu_code_key UNIQUE (code);


--
-- Name: user_mgmt_menu user_mgmt_menu_name_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menu
    ADD CONSTRAINT user_mgmt_menu_name_key UNIQUE (name);


--
-- Name: user_mgmt_menu user_mgmt_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menu
    ADD CONSTRAINT user_mgmt_menu_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_menupermission user_mgmt_menupermission_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menupermission
    ADD CONSTRAINT user_mgmt_menupermission_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_role_menus user_mgmt_role_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role_menus
    ADD CONSTRAINT user_mgmt_role_menus_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_role_menus user_mgmt_role_menus_role_id_menu_id_2fbf7103_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role_menus
    ADD CONSTRAINT user_mgmt_role_menus_role_id_menu_id_2fbf7103_uniq UNIQUE (role_id, menu_id);


--
-- Name: user_mgmt_role user_mgmt_role_name_909eab30_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role
    ADD CONSTRAINT user_mgmt_role_name_909eab30_uniq UNIQUE (name);


--
-- Name: user_mgmt_role user_mgmt_role_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role
    ADD CONSTRAINT user_mgmt_role_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_user user_mgmt_user_email_9335ea2d_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user
    ADD CONSTRAINT user_mgmt_user_email_9335ea2d_uniq UNIQUE (email);


--
-- Name: user_mgmt_user_groups user_mgmt_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_groups
    ADD CONSTRAINT user_mgmt_user_groups_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_user_groups user_mgmt_user_groups_user_id_group_id_b3d1387a_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_groups
    ADD CONSTRAINT user_mgmt_user_groups_user_id_group_id_b3d1387a_uniq UNIQUE (user_id, group_id);


--
-- Name: user_mgmt_user user_mgmt_user_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user
    ADD CONSTRAINT user_mgmt_user_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_user_roles user_mgmt_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_roles
    ADD CONSTRAINT user_mgmt_user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_user_roles user_mgmt_user_roles_user_id_role_id_e7847b59_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_roles
    ADD CONSTRAINT user_mgmt_user_roles_user_id_role_id_e7847b59_uniq UNIQUE (user_id, role_id);


--
-- Name: user_mgmt_user_user_permissions user_mgmt_user_user_perm_user_id_permission_id_9ea16ee8_uniq; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_user_permissions
    ADD CONSTRAINT user_mgmt_user_user_perm_user_id_permission_id_9ea16ee8_uniq UNIQUE (user_id, permission_id);


--
-- Name: user_mgmt_user_user_permissions user_mgmt_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_user_permissions
    ADD CONSTRAINT user_mgmt_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: user_mgmt_user user_mgmt_user_username_key; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user
    ADD CONSTRAINT user_mgmt_user_username_key UNIQUE (username);


--
-- Name: user_mgmt_userpost user_mgmt_userpost_pkey; Type: CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_userpost
    ADD CONSTRAINT user_mgmt_userpost_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: axes_accessattempt_ip_address_10922d9c; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accessattempt_ip_address_10922d9c ON public.axes_accessattempt USING btree (ip_address);


--
-- Name: axes_accessattempt_user_agent_ad89678b; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accessattempt_user_agent_ad89678b ON public.axes_accessattempt USING btree (user_agent);


--
-- Name: axes_accessattempt_user_agent_ad89678b_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accessattempt_user_agent_ad89678b_like ON public.axes_accessattempt USING btree (user_agent varchar_pattern_ops);


--
-- Name: axes_accessattempt_username_3f2d4ca0; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accessattempt_username_3f2d4ca0 ON public.axes_accessattempt USING btree (username);


--
-- Name: axes_accessattempt_username_3f2d4ca0_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accessattempt_username_3f2d4ca0_like ON public.axes_accessattempt USING btree (username varchar_pattern_ops);


--
-- Name: axes_accesslog_ip_address_86b417e5; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accesslog_ip_address_86b417e5 ON public.axes_accesslog USING btree (ip_address);


--
-- Name: axes_accesslog_user_agent_0e659004; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accesslog_user_agent_0e659004 ON public.axes_accesslog USING btree (user_agent);


--
-- Name: axes_accesslog_user_agent_0e659004_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accesslog_user_agent_0e659004_like ON public.axes_accesslog USING btree (user_agent varchar_pattern_ops);


--
-- Name: axes_accesslog_username_df93064b; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accesslog_username_df93064b ON public.axes_accesslog USING btree (username);


--
-- Name: axes_accesslog_username_df93064b_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX axes_accesslog_username_df93064b_like ON public.axes_accesslog USING btree (username varchar_pattern_ops);


--
-- Name: core_answer_created_by_id_1f060822; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_answer_created_by_id_1f060822 ON public.core_answer USING btree (created_by_id);


--
-- Name: core_answer_created_by_level_id_9e16d1c9; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_answer_created_by_level_id_9e16d1c9 ON public.core_answer USING btree (created_by_level_id);


--
-- Name: core_answer_fill_survey_id_7d3ccf5c; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_answer_fill_survey_id_7d3ccf5c ON public.core_answer USING btree (fill_survey_id);


--
-- Name: core_answer_fiscal_year_id_06288995; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_answer_fiscal_year_id_06288995 ON public.core_answer USING btree (fiscal_year_id);


--
-- Name: core_answer_option_id_aa493780; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_answer_option_id_aa493780 ON public.core_answer USING btree (option_id);


--
-- Name: core_answerdocument_answer_id_5ce72f0c; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_answerdocument_answer_id_5ce72f0c ON public.core_answerdocument USING btree (answer_id);


--
-- Name: core_appraisalreviewrequest_level_id_1a61cce9; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_appraisalreviewrequest_level_id_1a61cce9 ON public.core_appraisalreviewrequest USING btree (level_id);


--
-- Name: core_appraisalreviewrequest_question_id_id_deabe9f0; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_appraisalreviewrequest_question_id_id_deabe9f0 ON public.core_appraisalreviewrequest USING btree (question_id_id);


--
-- Name: core_appraisalreviewrequest_user_id_9140ec81; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_appraisalreviewrequest_user_id_9140ec81 ON public.core_appraisalreviewrequest USING btree (user_id);


--
-- Name: core_centralbody_name_bc92bc45_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_centralbody_name_bc92bc45_like ON public.core_centralbody USING btree (name varchar_pattern_ops);


--
-- Name: core_centralbody_name_np_a9adeaea_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_centralbody_name_np_a9adeaea_like ON public.core_centralbody USING btree (name_np varchar_pattern_ops);


--
-- Name: core_complaint_level_id_c610f5a0; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_complaint_level_id_c610f5a0 ON public.core_complaint USING btree (level_id);


--
-- Name: core_complaint_user_id_7131367a; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_complaint_user_id_7131367a ON public.core_complaint USING btree (user_id);


--
-- Name: core_fillsurvey_created_by_id_9130054e; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_fillsurvey_created_by_id_9130054e ON public.core_fillsurvey USING btree (created_by_id);


--
-- Name: core_fillsurvey_level_id_id_154e6156; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_fillsurvey_level_id_id_154e6156 ON public.core_fillsurvey USING btree (level_id_id);


--
-- Name: core_fillsurvey_survey_id_0af9c1ba; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_fillsurvey_survey_id_0af9c1ba ON public.core_fillsurvey USING btree (survey_id);


--
-- Name: core_fiscalyear_name_ee9780ad_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_fiscalyear_name_ee9780ad_like ON public.core_fiscalyear USING btree (name varchar_pattern_ops);


--
-- Name: core_localbody_name_44e80741_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_localbody_name_44e80741_like ON public.core_localbody USING btree (name varchar_pattern_ops);


--
-- Name: core_localbody_name_np_e33aebf7_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_localbody_name_np_e33aebf7_like ON public.core_localbody USING btree (name_np varchar_pattern_ops);


--
-- Name: core_localbody_province_id_89618169; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_localbody_province_id_89618169 ON public.core_localbody USING btree (province_id);


--
-- Name: core_notification_correction_id_4e7d3747; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_notification_correction_id_4e7d3747 ON public.core_notification USING btree (correction_id);


--
-- Name: core_notification_level_id_f0a76a20; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_notification_level_id_f0a76a20 ON public.core_notification USING btree (level_id);


--
-- Name: core_notification_question_id_71c2684a; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_notification_question_id_71c2684a ON public.core_notification USING btree (question_id);


--
-- Name: core_notification_user_id_6e341aac; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_notification_user_id_6e341aac ON public.core_notification USING btree (user_id);


--
-- Name: core_option_created_by_id_2015972f; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_option_created_by_id_2015972f ON public.core_option USING btree (created_by_id);


--
-- Name: core_option_question_id_290bbdf0; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_option_question_id_290bbdf0 ON public.core_option USING btree (question_id);


--
-- Name: core_provincebody_central_id_2113aec3; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_provincebody_central_id_2113aec3 ON public.core_provincebody USING btree (central_id);


--
-- Name: core_provincebody_name_994dba55_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_provincebody_name_994dba55_like ON public.core_provincebody USING btree (name varchar_pattern_ops);


--
-- Name: core_provincebody_name_np_7174196a_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_provincebody_name_np_7174196a_like ON public.core_provincebody USING btree (name_np varchar_pattern_ops);


--
-- Name: core_question_department_id_2c137764; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_question_department_id_2c137764 ON public.core_question USING btree (department_id);


--
-- Name: core_question_parent_id_cd5e2951; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_question_parent_id_cd5e2951 ON public.core_question USING btree (parent_id);


--
-- Name: core_question_survey_id_4f31350e; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_question_survey_id_4f31350e ON public.core_question USING btree (survey_id);


--
-- Name: core_survey_fiscal_year_id_2fd4605a; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_survey_fiscal_year_id_2fd4605a ON public.core_survey USING btree (fiscal_year_id);


--
-- Name: core_survey_name_1d2456ee_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_survey_name_1d2456ee_like ON public.core_survey USING btree (name varchar_pattern_ops);


--
-- Name: core_surveycorrection_level_id_9a27e78d; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_surveycorrection_level_id_9a27e78d ON public.core_surveycorrection USING btree (level_id);


--
-- Name: core_surveycorrection_question_id_e7b5e0ae; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_surveycorrection_question_id_e7b5e0ae ON public.core_surveycorrection USING btree (question_id);


--
-- Name: core_surveycorrection_user_id_e26d4045; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX core_surveycorrection_user_id_e26d4045 ON public.core_surveycorrection USING btree (user_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- Name: user_mgmt_level_district_id_69fa0e51; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_level_district_id_69fa0e51 ON public.user_mgmt_level USING btree (district_id);


--
-- Name: user_mgmt_level_province_level_id_6db87cbd; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_level_province_level_id_6db87cbd ON public.user_mgmt_level USING btree (province_level_id);


--
-- Name: user_mgmt_level_type_id_0872699c; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_level_type_id_0872699c ON public.user_mgmt_level USING btree (type_id);


--
-- Name: user_mgmt_menu_code_32c3add1_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_menu_code_32c3add1_like ON public.user_mgmt_menu USING btree (code varchar_pattern_ops);


--
-- Name: user_mgmt_menu_name_29da1b2d_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_menu_name_29da1b2d_like ON public.user_mgmt_menu USING btree (name varchar_pattern_ops);


--
-- Name: user_mgmt_menu_parent_id_31c7cbec; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_menu_parent_id_31c7cbec ON public.user_mgmt_menu USING btree (parent_id);


--
-- Name: user_mgmt_menupermission_menu_id_cf8e7158; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_menupermission_menu_id_cf8e7158 ON public.user_mgmt_menupermission USING btree (menu_id);


--
-- Name: user_mgmt_menupermission_role_id_fc43a0c1; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_menupermission_role_id_fc43a0c1 ON public.user_mgmt_menupermission USING btree (role_id);


--
-- Name: user_mgmt_role_menus_menu_id_6cef244f; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_role_menus_menu_id_6cef244f ON public.user_mgmt_role_menus USING btree (menu_id);


--
-- Name: user_mgmt_role_menus_role_id_04a91ea5; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_role_menus_role_id_04a91ea5 ON public.user_mgmt_role_menus USING btree (role_id);


--
-- Name: user_mgmt_role_name_909eab30_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_role_name_909eab30_like ON public.user_mgmt_role USING btree (name varchar_pattern_ops);


--
-- Name: user_mgmt_user_department_id_fb119b2f; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_department_id_fb119b2f ON public.user_mgmt_user USING btree (department_id);


--
-- Name: user_mgmt_user_email_9335ea2d_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_email_9335ea2d_like ON public.user_mgmt_user USING btree (email varchar_pattern_ops);


--
-- Name: user_mgmt_user_groups_group_id_908ad644; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_groups_group_id_908ad644 ON public.user_mgmt_user_groups USING btree (group_id);


--
-- Name: user_mgmt_user_groups_user_id_1de01799; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_groups_user_id_1de01799 ON public.user_mgmt_user_groups USING btree (user_id);


--
-- Name: user_mgmt_user_level_id_c53d2a98; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_level_id_c53d2a98 ON public.user_mgmt_user USING btree (level_id);


--
-- Name: user_mgmt_user_post_id_0ebf0496; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_post_id_0ebf0496 ON public.user_mgmt_user USING btree (post_id);


--
-- Name: user_mgmt_user_roles_role_id_47eaabf1; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_roles_role_id_47eaabf1 ON public.user_mgmt_user_roles USING btree (role_id);


--
-- Name: user_mgmt_user_roles_user_id_050c0ba0; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_roles_user_id_050c0ba0 ON public.user_mgmt_user_roles USING btree (user_id);


--
-- Name: user_mgmt_user_user_permissions_permission_id_4f8bacf5; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_user_permissions_permission_id_4f8bacf5 ON public.user_mgmt_user_user_permissions USING btree (permission_id);


--
-- Name: user_mgmt_user_user_permissions_user_id_9b9f4347; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_user_permissions_user_id_9b9f4347 ON public.user_mgmt_user_user_permissions USING btree (user_id);


--
-- Name: user_mgmt_user_username_145ffc04_like; Type: INDEX; Schema: public; Owner: nnrfc
--

CREATE INDEX user_mgmt_user_username_145ffc04_like ON public.user_mgmt_user USING btree (username varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_answer core_answer_created_by_id_1f060822_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer
    ADD CONSTRAINT core_answer_created_by_id_1f060822_fk_user_mgmt_user_id FOREIGN KEY (created_by_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_answer core_answer_created_by_level_id_9e16d1c9_fk_user_mgmt_level_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer
    ADD CONSTRAINT core_answer_created_by_level_id_9e16d1c9_fk_user_mgmt_level_id FOREIGN KEY (created_by_level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_answer core_answer_fill_survey_id_7d3ccf5c_fk_core_fillsurvey_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer
    ADD CONSTRAINT core_answer_fill_survey_id_7d3ccf5c_fk_core_fillsurvey_id FOREIGN KEY (fill_survey_id) REFERENCES public.core_fillsurvey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_answer core_answer_fiscal_year_id_06288995_fk_core_fiscalyear_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer
    ADD CONSTRAINT core_answer_fiscal_year_id_06288995_fk_core_fiscalyear_id FOREIGN KEY (fiscal_year_id) REFERENCES public.core_fiscalyear(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_answer core_answer_option_id_aa493780_fk_core_option_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answer
    ADD CONSTRAINT core_answer_option_id_aa493780_fk_core_option_id FOREIGN KEY (option_id) REFERENCES public.core_option(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_answerdocument core_answerdocument_answer_id_5ce72f0c_fk_core_answer_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_answerdocument
    ADD CONSTRAINT core_answerdocument_answer_id_5ce72f0c_fk_core_answer_id FOREIGN KEY (answer_id) REFERENCES public.core_answer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_appraisalreviewrequest core_appraisalreview_level_id_1a61cce9_fk_user_mgmt; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_appraisalreviewrequest
    ADD CONSTRAINT core_appraisalreview_level_id_1a61cce9_fk_user_mgmt FOREIGN KEY (level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_appraisalreviewrequest core_appraisalreview_question_id_id_deabe9f0_fk_core_ques; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_appraisalreviewrequest
    ADD CONSTRAINT core_appraisalreview_question_id_id_deabe9f0_fk_core_ques FOREIGN KEY (question_id_id) REFERENCES public.core_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_appraisalreviewrequest core_appraisalreview_user_id_9140ec81_fk_user_mgmt; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_appraisalreviewrequest
    ADD CONSTRAINT core_appraisalreview_user_id_9140ec81_fk_user_mgmt FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_complaint core_complaint_level_id_c610f5a0_fk_user_mgmt_level_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_complaint
    ADD CONSTRAINT core_complaint_level_id_c610f5a0_fk_user_mgmt_level_id FOREIGN KEY (level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_complaint core_complaint_user_id_7131367a_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_complaint
    ADD CONSTRAINT core_complaint_user_id_7131367a_fk_user_mgmt_user_id FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_fillsurvey core_fillsurvey_created_by_id_9130054e_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fillsurvey
    ADD CONSTRAINT core_fillsurvey_created_by_id_9130054e_fk_user_mgmt_user_id FOREIGN KEY (created_by_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_fillsurvey core_fillsurvey_level_id_id_154e6156_fk_user_mgmt_level_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fillsurvey
    ADD CONSTRAINT core_fillsurvey_level_id_id_154e6156_fk_user_mgmt_level_id FOREIGN KEY (level_id_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_fillsurvey core_fillsurvey_survey_id_0af9c1ba_fk_core_survey_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_fillsurvey
    ADD CONSTRAINT core_fillsurvey_survey_id_0af9c1ba_fk_core_survey_id FOREIGN KEY (survey_id) REFERENCES public.core_survey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_localbody core_localbody_province_id_89618169_fk_core_provincebody_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_localbody
    ADD CONSTRAINT core_localbody_province_id_89618169_fk_core_provincebody_id FOREIGN KEY (province_id) REFERENCES public.core_provincebody(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_notification core_notification_correction_id_4e7d3747_fk_core_surv; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_notification
    ADD CONSTRAINT core_notification_correction_id_4e7d3747_fk_core_surv FOREIGN KEY (correction_id) REFERENCES public.core_surveycorrection(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_notification core_notification_level_id_f0a76a20_fk_user_mgmt_level_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_notification
    ADD CONSTRAINT core_notification_level_id_f0a76a20_fk_user_mgmt_level_id FOREIGN KEY (level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_notification core_notification_question_id_71c2684a_fk_core_question_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_notification
    ADD CONSTRAINT core_notification_question_id_71c2684a_fk_core_question_id FOREIGN KEY (question_id) REFERENCES public.core_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_notification core_notification_user_id_6e341aac_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_notification
    ADD CONSTRAINT core_notification_user_id_6e341aac_fk_user_mgmt_user_id FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_option core_option_created_by_id_2015972f_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_option
    ADD CONSTRAINT core_option_created_by_id_2015972f_fk_user_mgmt_user_id FOREIGN KEY (created_by_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_option core_option_question_id_290bbdf0_fk_core_question_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_option
    ADD CONSTRAINT core_option_question_id_290bbdf0_fk_core_question_id FOREIGN KEY (question_id) REFERENCES public.core_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_provincebody core_provincebody_central_id_2113aec3_fk_core_centralbody_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_provincebody
    ADD CONSTRAINT core_provincebody_central_id_2113aec3_fk_core_centralbody_id FOREIGN KEY (central_id) REFERENCES public.core_centralbody(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_question core_question_department_id_2c137764_fk_user_mgmt_department_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_question
    ADD CONSTRAINT core_question_department_id_2c137764_fk_user_mgmt_department_id FOREIGN KEY (department_id) REFERENCES public.user_mgmt_department(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_question core_question_parent_id_cd5e2951_fk_core_question_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_question
    ADD CONSTRAINT core_question_parent_id_cd5e2951_fk_core_question_id FOREIGN KEY (parent_id) REFERENCES public.core_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_question core_question_survey_id_4f31350e_fk_core_survey_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_question
    ADD CONSTRAINT core_question_survey_id_4f31350e_fk_core_survey_id FOREIGN KEY (survey_id) REFERENCES public.core_survey(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_survey core_survey_fiscal_year_id_2fd4605a_fk_core_fiscalyear_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_survey
    ADD CONSTRAINT core_survey_fiscal_year_id_2fd4605a_fk_core_fiscalyear_id FOREIGN KEY (fiscal_year_id) REFERENCES public.core_fiscalyear(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_surveycorrection core_surveycorrection_level_id_9a27e78d_fk_user_mgmt_level_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_surveycorrection
    ADD CONSTRAINT core_surveycorrection_level_id_9a27e78d_fk_user_mgmt_level_id FOREIGN KEY (level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_surveycorrection core_surveycorrection_question_id_e7b5e0ae_fk_core_question_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_surveycorrection
    ADD CONSTRAINT core_surveycorrection_question_id_e7b5e0ae_fk_core_question_id FOREIGN KEY (question_id) REFERENCES public.core_question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: core_surveycorrection core_surveycorrection_user_id_e26d4045_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.core_surveycorrection
    ADD CONSTRAINT core_surveycorrection_user_id_e26d4045_fk_user_mgmt_user_id FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_user_mgmt_user_id FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_level user_mgmt_level_district_id_69fa0e51_fk_user_mgmt_district_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_level
    ADD CONSTRAINT user_mgmt_level_district_id_69fa0e51_fk_user_mgmt_district_id FOREIGN KEY (district_id) REFERENCES public.user_mgmt_district(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_level user_mgmt_level_province_level_id_6db87cbd_fk_user_mgmt; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_level
    ADD CONSTRAINT user_mgmt_level_province_level_id_6db87cbd_fk_user_mgmt FOREIGN KEY (province_level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_level user_mgmt_level_type_id_0872699c_fk_user_mgmt_leveltype_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_level
    ADD CONSTRAINT user_mgmt_level_type_id_0872699c_fk_user_mgmt_leveltype_id FOREIGN KEY (type_id) REFERENCES public.user_mgmt_leveltype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_menu user_mgmt_menu_parent_id_31c7cbec_fk_user_mgmt_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menu
    ADD CONSTRAINT user_mgmt_menu_parent_id_31c7cbec_fk_user_mgmt_menu_id FOREIGN KEY (parent_id) REFERENCES public.user_mgmt_menu(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_menupermission user_mgmt_menupermission_menu_id_cf8e7158_fk_user_mgmt_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menupermission
    ADD CONSTRAINT user_mgmt_menupermission_menu_id_cf8e7158_fk_user_mgmt_menu_id FOREIGN KEY (menu_id) REFERENCES public.user_mgmt_menu(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_menupermission user_mgmt_menupermission_role_id_fc43a0c1_fk_user_mgmt_role_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_menupermission
    ADD CONSTRAINT user_mgmt_menupermission_role_id_fc43a0c1_fk_user_mgmt_role_id FOREIGN KEY (role_id) REFERENCES public.user_mgmt_role(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_role_menus user_mgmt_role_menus_menu_id_6cef244f_fk_user_mgmt_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role_menus
    ADD CONSTRAINT user_mgmt_role_menus_menu_id_6cef244f_fk_user_mgmt_menu_id FOREIGN KEY (menu_id) REFERENCES public.user_mgmt_menu(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_role_menus user_mgmt_role_menus_role_id_04a91ea5_fk_user_mgmt_role_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_role_menus
    ADD CONSTRAINT user_mgmt_role_menus_role_id_04a91ea5_fk_user_mgmt_role_id FOREIGN KEY (role_id) REFERENCES public.user_mgmt_role(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user user_mgmt_user_department_id_fb119b2f_fk_user_mgmt; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user
    ADD CONSTRAINT user_mgmt_user_department_id_fb119b2f_fk_user_mgmt FOREIGN KEY (department_id) REFERENCES public.user_mgmt_department(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user_groups user_mgmt_user_groups_group_id_908ad644_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_groups
    ADD CONSTRAINT user_mgmt_user_groups_group_id_908ad644_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user_groups user_mgmt_user_groups_user_id_1de01799_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_groups
    ADD CONSTRAINT user_mgmt_user_groups_user_id_1de01799_fk_user_mgmt_user_id FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user user_mgmt_user_level_id_c53d2a98_fk_user_mgmt_level_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user
    ADD CONSTRAINT user_mgmt_user_level_id_c53d2a98_fk_user_mgmt_level_id FOREIGN KEY (level_id) REFERENCES public.user_mgmt_level(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user user_mgmt_user_post_id_0ebf0496_fk_user_mgmt_userpost_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user
    ADD CONSTRAINT user_mgmt_user_post_id_0ebf0496_fk_user_mgmt_userpost_id FOREIGN KEY (post_id) REFERENCES public.user_mgmt_userpost(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user_roles user_mgmt_user_roles_role_id_47eaabf1_fk_user_mgmt_role_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_roles
    ADD CONSTRAINT user_mgmt_user_roles_role_id_47eaabf1_fk_user_mgmt_role_id FOREIGN KEY (role_id) REFERENCES public.user_mgmt_role(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user_roles user_mgmt_user_roles_user_id_050c0ba0_fk_user_mgmt_user_id; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_roles
    ADD CONSTRAINT user_mgmt_user_roles_user_id_050c0ba0_fk_user_mgmt_user_id FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user_user_permissions user_mgmt_user_user__permission_id_4f8bacf5_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_user_permissions
    ADD CONSTRAINT user_mgmt_user_user__permission_id_4f8bacf5_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_mgmt_user_user_permissions user_mgmt_user_user__user_id_9b9f4347_fk_user_mgmt; Type: FK CONSTRAINT; Schema: public; Owner: nnrfc
--

ALTER TABLE ONLY public.user_mgmt_user_user_permissions
    ADD CONSTRAINT user_mgmt_user_user__user_id_9b9f4347_fk_user_mgmt FOREIGN KEY (user_id) REFERENCES public.user_mgmt_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

